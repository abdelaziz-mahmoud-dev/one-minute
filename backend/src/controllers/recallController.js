const Recall = require("../models/Recall");
const Minute = require("../models/Minute");

const {
  calculateNextRecall,
  getNextReviewDate
} = require("../utils/recall");

const getRecallItems = async (req, res) => {
  const now = new Date();

  const recalls = await Recall.find({
    user: req.user._id,
    dueAt: { $lte: now }
  })
    .populate(
      "minute",
      "title slug content keyTakeaway question xpReward"
    )
    .sort({ dueAt: 1 })
    .limit(10);

  res.status(200).json({
    success: true,
    data: {
      count: recalls.length,
      recalls
    }
  });
};

const answerRecall = async (req, res) => {
  const { score } = req.body;

  if (
    typeof score !== "number" ||
    !Number.isInteger(score) ||
    score < 0 ||
    score > 5
  ) {
    return res.status(400).json({
      success: false,
      message: "Score must be an integer between 0 and 5"
    });
  }

  const recall = await Recall.findOne({
    _id: req.params.id,
    user: req.user._id
  });

  if (!recall) {
    return res.status(404).json({
      success: false,
      message: "Recall item not found"
    });
  }

  const nextInterval = calculateNextRecall(
    score,
    recall.intervalDays
  );

  recall.recallScore = score;
  recall.intervalDays = nextInterval;
  recall.attempts += 1;
  recall.lastReviewedAt = new Date();
  recall.dueAt = getNextReviewDate(nextInterval);

  await recall.save();

  res.status(200).json({
    success: true,
    message: "Recall updated successfully",
    data: {
      score,
      nextReviewAt: recall.dueAt,
      intervalDays: recall.intervalDays
    }
  });
};

const createRecallForMinute = async (userId, minuteId) => {
  const existingRecall = await Recall.findOne({
    user: userId,
    minute: minuteId
  });

  if (existingRecall) {
    return existingRecall;
  }

  return Recall.create({
    user: userId,
    minute: minuteId,
    dueAt: new Date()
  });
};

module.exports = {
  getRecallItems,
  answerRecall,
  createRecallForMinute
};