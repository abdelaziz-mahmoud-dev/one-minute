const mongoose = require("mongoose");

const recallSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true
    },

    minute: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Minute",
      required: true
    },

    dueAt: {
      type: Date,
      default: Date.now
    },

    intervalDays: {
      type: Number,
      default: 1,
      min: 1
    },

    recallScore: {
      type: Number,
      default: 0,
      min: 0,
      max: 5
    },

    attempts: {
      type: Number,
      default: 0,
      min: 0
    },

    lastReviewedAt: {
      type: Date,
      default: null
    }
  },
  {
    timestamps: true
  }
);

recallSchema.index(
  { user: 1, minute: 1 },
  { unique: true }
);

recallSchema.index({
  user: 1,
  dueAt: 1
});

module.exports = mongoose.model("Recall", recallSchema);