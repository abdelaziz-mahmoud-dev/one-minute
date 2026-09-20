const Minute = require("../models/Minute");
const UserProgress = require("../models/UserProgress");

const getDailyMinute = async (req, res) => {
  const completedMinutes = await UserProgress.find({
    user: req.user._id,
    completed: true
  })
    .select("minute -_id")
    .lean();

  const completedIds = completedMinutes.map((item) => item.minute);

  const baseQuery = {
    isPublished: true,
    _id: { $nin: completedIds }
  };

  let minute = null;

  if (req.user.interests.length > 0) {
    minute = await Minute.findOne({
      ...baseQuery,
      category: { $in: req.user.interests }
    })
      .populate("category", "name slug icon")
      .populate("learningPath", "title slug")
      .sort({ order: 1 })
      .lean();
  }

  if (!minute) {
    minute = await Minute.findOne(baseQuery)
      .populate("category", "name slug icon")
      .populate("learningPath", "title slug")
      .sort({ createdAt: 1 })
      .lean();
  }

  if (!minute) {
    minute = await Minute.findOne({
      isPublished: true
    })
      .populate("category", "name slug icon")
      .populate("learningPath", "title slug")
      .sort({ createdAt: 1 })
      .lean();
  }

  if (!minute) {
    return res.status(404).json({
      success: false,
      message: "No daily minute available"
    });
  }

  return res.status(200).json({
    success: true,
    data: {
      minute
    }
  });
};

module.exports = {
  getDailyMinute
};