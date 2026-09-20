const User = require("../models/User");
const Minute = require("../models/Minute");
const UserProgress = require("../models/UserProgress");

const {
  calculateLevel,
  getNextLevelXp,
  updateStreak
} = require("../utils/progress");

const {
  createRecallForMinute
} = require("./recallController");

const getProgress = async (req, res) => {
  const page = Math.max(
    Number.parseInt(req.query.page, 10) || 1,
    1
  );

  const limit = Math.min(
    Math.max(
      Number.parseInt(req.query.limit, 10) || 20,
      1
    ),
    50
  );

  const skip = (page - 1) * limit;

  const userId = req.user._id;

  const [
    progress,
    total,
    completedMinutes,
    user
  ] = await Promise.all([
    UserProgress.find({
      user: userId
    })
      .populate(
        "minute",
        "title slug category learningPath xpReward"
      )
      .sort({
        completedAt: -1,
        updatedAt: -1
      })
      .skip(skip)
      .limit(limit),

    UserProgress.countDocuments({
      user: userId
    }),

    UserProgress.countDocuments({
      user: userId,
      completed: true
    }),

    User.findById(userId).select(
      "xp level streak"
    )
  ]);

  if (!user) {
    return res.status(404).json({
      success: false,
      message: "User not found"
    });
  }

  res.status(200).json({
    success: true,
    data: {
      summary: {
        xp: user.xp,
        level: user.level,
        streak: user.streak,
        nextLevelXp: getNextLevelXp(user.level),
        completedMinutes
      },

      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit)
      },

      progress
    }
  });
};

const getMyProgress = async (req, res) => {
  const progress = await UserProgress.find({
    user: req.user._id,
    completed: true
  })
    .populate(
      "minute",
      "title slug category learningPath xpReward"
    )
    .sort({
      completedAt: -1
    });

  res.status(200).json({
    success: true,
    data: {
      progress
    }
  });
};

const answerMinute = async (req, res) => {
  const { answer } = req.body;

  if (
    typeof answer !== "number" ||
    !Number.isInteger(answer)
  ) {
    return res.status(400).json({
      success: false,
      message: "Answer must be an integer"
    });
  }

  const minute = await Minute.findOne({
    _id: req.params.id,
    isPublished: true
  });

  if (!minute) {
    return res.status(404).json({
      success: false,
      message: "Minute not found"
    });
  }

  if (
    answer < 0 ||
    answer >= minute.question.options.length
  ) {
    return res.status(400).json({
      success: false,
      message: "Invalid answer"
    });
  }

  const userId = req.user._id;
  const isCorrect =
    answer === minute.question.correctAnswer;

  /*
   * Make sure the progress document exists.
   *
   * The unique index on { user, minute } protects us
   * from having more than one progress document.
   */
  await UserProgress.updateOne(
    {
      user: userId,
      minute: minute._id
    },
    {
      $setOnInsert: {
        user: userId,
        minute: minute._id
      }
    },
    {
      upsert: true
    }
  );

  /*
   * Every answer counts as an attempt.
   *
   * If the answer is wrong, only attempts/correct change.
   *
   * If the answer is correct AND the minute was not
   * completed before, this atomic update is the gate
   * that decides who gets the XP.
   */
  const progressUpdate = {
    $inc: {
      attempts: 1
    },
    $set: {
      correct: isCorrect
    }
  };

  if (isCorrect) {
    progressUpdate.$set.completed = true;
    progressUpdate.$set.completedAt = new Date();
    progressUpdate.$set.xpEarned =
      minute.xpReward;
  }

  const updatedProgress =
    await UserProgress.findOneAndUpdate(
      {
        user: userId,
        minute: minute._id,
        ...(isCorrect
          ? {
              completed: false
            }
          : {})
      },
      progressUpdate,
      {
        new: true
      }
    );

  /*
   * If the correct answer was submitted after another
   * request already completed the minute, updatedProgress
   * will be null.
   *
   * Therefore XP can only be awarded by the request
   * that actually changed completed from false → true.
   */
  const newlyCompleted =
    isCorrect && updatedProgress !== null;

  let user = null;

  if (newlyCompleted) {
    user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found"
      });
    }

    user.xp += minute.xpReward;
    user.level = calculateLevel(user.xp);

    updateStreak(user);

    await user.save();

    await createRecallForMinute(
      userId,
      minute._id
    );
  }

  const progress =
    updatedProgress ??
    await UserProgress.findOne({
      user: userId,
      minute: minute._id
    });

  if (!progress) {
    return res.status(500).json({
      success: false,
      message: "Unable to update progress"
    });
  }

  if (!user && newlyCompleted === false) {
    user = await User.findById(userId).select(
      "xp level streak"
    );
  }

  res.status(200).json({
    success: true,
    data: {
      correct: isCorrect,
      completed: progress.completed,
      attempts: progress.attempts,
      xpEarned: newlyCompleted
        ? minute.xpReward
        : 0,
      totalXp: user?.xp,
      level: user?.level,
      streak: user?.streak,
      explanation:
        minute.question.explanation
    }
  });
};

module.exports = {
  getProgress,
  getMyProgress,
  answerMinute
};