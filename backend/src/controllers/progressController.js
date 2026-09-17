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

  const [progress, total, user] =
    await Promise.all([
      UserProgress.find({
        user: req.user._id
      })
        .populate(
          "minute",
          "title slug category learningPath xpReward"
        )
        .sort({ completedAt: -1 })
        .skip(skip)
        .limit(limit),

      UserProgress.countDocuments({
        user: req.user._id
      }),

      User.findById(req.user._id)
    ]);

  res.status(200).json({
    success: true,
    data: {
      xp: user.xp,
      level: user.level,
      streak: user.streak,
      nextLevelXp: getNextLevelXp(user.level),
      completedMinutes: await UserProgress.countDocuments({
        user: req.user._id,
        completed: true
      }),
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
    .sort({ completedAt: -1 });

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

  let progress = await UserProgress.findOne({
    user: req.user._id,
    minute: minute._id
  });

  if (!progress) {
    progress = new UserProgress({
      user: req.user._id,
      minute: minute._id
    });
  }

  progress.attempts += 1;

  const isCorrect =
    answer === minute.question.correctAnswer;

  progress.correct = isCorrect;

  let earnedXp = 0;

  if (isCorrect && !progress.completed) {
    progress.completed = true;
    progress.completedAt = new Date();
    progress.xpEarned = minute.xpReward;

    earnedXp = minute.xpReward;

    const user = await User.findById(req.user._id);

    user.xp += minute.xpReward;
    user.level = calculateLevel(user.xp);

    updateStreak(user);

    await user.save();

    await createRecallForMinute(
      req.user._id,
      minute._id
    );
  }

  await progress.save();

  res.status(200).json({
    success: true,
    data: {
      correct: isCorrect,
      completed: progress.completed,
      attempts: progress.attempts,
      xpEarned: earnedXp,
      totalXp: progress.completed
        ? (await User.findById(req.user._id)).xp
        : undefined,
      explanation: minute.question.explanation
    }
  });
};

module.exports = {
  getProgress,
  getMyProgress,
  answerMinute
};