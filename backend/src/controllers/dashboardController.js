const User = require("../models/User");
const UserProgress = require("../models/UserProgress");
const Recall = require("../models/Recall");

const getDashboard = async (req, res) => {
  const user = await User.findById(req.user._id)
    .populate("interests", "name slug icon");

  const completedMinutes =
    await UserProgress.countDocuments({
      user: user._id,
      completed: true
    });

  const dueRecalls =
    await Recall.countDocuments({
      user: user._id,
      dueAt: { $lte: new Date() }
    });

  const recentProgress =
    await UserProgress.find({
      user: user._id,
      completed: true
    })
      .populate(
        "minute",
        "title slug xpReward category learningPath"
      )
      .sort({ completedAt: -1 })
      .limit(5);

  res.status(200).json({
    success: true,
    data: {
      user: {
        id: user._id,
        name: user.name,
        avatar: user.avatar,
        xp: user.xp,
        level: user.level,
        streak: user.streak,
        interests: user.interests
      },

      stats: {
        completedMinutes,
        dueRecalls,
        nextLevelXp: user.level * 100
      },

      recentProgress
    }
  });
};

module.exports = {
  getDashboard
};