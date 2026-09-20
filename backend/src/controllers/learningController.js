const Category = require("../models/Category");
const LearningPath = require("../models/LearningPath");
const Minute = require("../models/Minute");
const UserProgress = require("../models/UserProgress");

const getCategories = async (req, res) => {
  const categories = await Category.find({
    isActive: true
  }).sort({ name: 1 });

  res.status(200).json({
    success: true,
    data: {
      categories
    }
  });
};

const getLearningPaths = async (req, res) => {
  const filter = {
    isPublished: true
  };

  if (req.query.category) {
    filter.category = req.query.category;
  }

  if (req.query.level) {
    filter.level = req.query.level;
  }

  const paths = await LearningPath.find(filter)
    .populate("category", "name slug icon")
    .sort({ createdAt: -1 });

  const pathIds = paths.map((path) => path._id);

  const minuteCounts = await Minute.aggregate([
    {
      $match: {
        learningPath: { $in: pathIds },
        isPublished: true
      }
    },
    {
      $group: {
        _id: "$learningPath",
        count: { $sum: 1 },
        minuteIds: { $push: "$_id" }
      }
    }
  ]);

  const minuteCountMap = {};
  const pathMinuteIds = {};

  minuteCounts.forEach((entry) => {
    minuteCountMap[entry._id.toString()] = entry.count;
    pathMinuteIds[entry._id.toString()] = entry.minuteIds;
  });

  const allMinuteIds = minuteCounts.flatMap(
    (entry) => entry.minuteIds
  );

  const completedProgress = await UserProgress.find({
    user: req.user._id,
    minute: { $in: allMinuteIds },
    completed: true
  }).select("minute");

  const completedMinuteIds = new Set(
    completedProgress.map((p) => p.minute.toString())
  );

  const pathsWithProgress = paths.map((path) => {
    const idString = path._id.toString();
    const minuteIds = pathMinuteIds[idString] || [];

    const completedMinutes = minuteIds.filter((minuteId) =>
      completedMinuteIds.has(minuteId.toString())
    ).length;

    return {
      ...path.toObject(),
      minuteCount: minuteCountMap[idString] || 0,
      completedMinutes
    };
  });

  res.status(200).json({
    success: true,
    data: {
      paths: pathsWithProgress
    }
  });
};

const getLearningPath = async (req, res) => {
  const path = await LearningPath.findOne({
    _id: req.params.id,
    isPublished: true
  }).populate("category", "name slug icon");

  if (!path) {
    return res.status(404).json({
      success: false,
      message: "Learning path not found"
    });
  }

  const minutes = await Minute.find({
    learningPath: path._id,
    isPublished: true
  })
    .select(
      "title slug level order xpReward keyTakeaway"
    )
    .sort({ order: 1 });

  const minuteIds = minutes.map((minute) => minute._id);

  const completedProgress = await UserProgress.find({
    user: req.user._id,
    minute: { $in: minuteIds },
    completed: true
  }).select("minute");

  const completedMinuteIds = new Set(
    completedProgress.map((p) => p.minute.toString())
  );

  const minutesWithStatus = minutes.map((minute) => ({
    ...minute.toObject(),
    isCompleted: completedMinuteIds.has(
      minute._id.toString()
    )
  }));

  res.status(200).json({
    success: true,
    data: {
      path: {
        ...path.toObject(),
        minuteCount: minutes.length,
        completedMinutes: completedMinuteIds.size
      },
      minutes: minutesWithStatus
    }
  });
};

const getMinute = async (req, res) => {
  const minute = await Minute.findOne({
    _id: req.params.id,
    isPublished: true
  })
    .populate("category", "name slug icon")
    .populate("learningPath", "title slug");

  if (!minute) {
    return res.status(404).json({
      success: false,
      message: "Minute not found"
    });
  }

  const progress = await UserProgress.findOne({
    user: req.user._id,
    minute: minute._id
  }).select("completed");

  res.status(200).json({
    success: true,
    data: {
      minute: {
        ...minute.toObject(),
        isCompleted: progress?.completed === true
      }
    }
  });
};

module.exports = {
  getCategories,
  getLearningPaths,
  getLearningPath,
  getMinute
};