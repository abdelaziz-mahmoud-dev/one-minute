const Minute = require("../models/Minute");
const UserProgress = require("../models/UserProgress");

const getDailyMinute = async (req, res) => {
  const completed = await UserProgress.find({
    user: req.user._id,
    completed: true
  }).select("minute");

  const completedIds = completed.map(
    (item) => item.minute
  );

  let minute = null;

  if (req.user.interests.length > 0) {
    minute = await Minute.findOne({
      category: { $in: req.user.interests },
      isPublished: true,
      _id: { $nin: completedIds }
    })
      .populate("category", "name slug icon")
      .populate("learningPath", "title slug")
      .sort({ order: 1 });
  }

  if (!minute) {
    minute = await Minute.findOne({
      isPublished: true,
      _id: { $nin: completedIds }
    })
      .populate("category", "name slug icon")
      .populate("learningPath", "title slug")
      .sort({ createdAt: 1 });
  }

  if (!minute) {
    minute = await Minute.findOne({
      isPublished: true
    })
      .populate("category", "name slug icon")
      .populate("learningPath", "title slug")
      .sort({ createdAt: 1 });
  }

  if (!minute) {
    return res.status(404).json({
      success: false,
      message: "No daily minute available"
    });
  }

  res.status(200).json({
    success: true,
    data: {
      minute
    }
  });
};

module.exports = {
  getDailyMinute
};