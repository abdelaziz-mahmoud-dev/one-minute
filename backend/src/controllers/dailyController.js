const Minute = require("../models/Minute");
const UserProgress = require("../models/UserProgress");

const getDailyMinute = async (req, res) => {
  const userId = req.user._id;

  const completed = await UserProgress.find({
    user: userId,
    completed: true
  }).select("minute");

  const completedIds = completed.map(
    (item) => item.minute
  );

  const baseQuery = {
    isPublished: true,
    _id: {
      $nin: completedIds
    }
  };

  let minute = null;

  // First priority:
  // unpublished/completed minutes are excluded,
  // and the user's interests are preferred.
  if (req.user.interests.length > 0) {
    minute = await Minute.findOne({
      ...baseQuery,
      category: {
        $in: req.user.interests
      }
    })
      .populate(
        "category",
        "name slug icon"
      )
      .populate(
        "learningPath",
        "title slug"
      )
      .sort({
        order: 1,
        createdAt: 1
      });
  }

  // Second priority:
  // if there is nothing matching the user's interests,
  // give them another unfinished published minute.
  if (!minute) {
    minute = await Minute.findOne(baseQuery)
      .populate(
        "category",
        "name slug icon"
      )
      .populate(
        "learningPath",
        "title slug"
      )
      .sort({
        createdAt: 1,
        order: 1
      });
  }

  // If the user completed everything, start the cycle again.
  // This is better than returning a 404 because the app
  // should always have something useful to show.
  if (!minute) {
    minute = await Minute.findOne({
      isPublished: true
    })
      .populate(
        "category",
        "name slug icon"
      )
      .populate(
        "learningPath",
        "title slug"
      )
      .sort({
        createdAt: 1,
        order: 1
      });
  }

  if (!minute) {
    return res.status(404).json({
      success: false,
      message: "No daily minute available"
    });
  }

  const isReview =
    completedIds.some(
      (id) => id.toString() === minute._id.toString()
    );

  res.status(200).json({
    success: true,
    data: {
      minute,
      isReview
    }
  });
};

module.exports = {
  getDailyMinute
};