const mongoose = require("mongoose");

const userProgressSchema = new mongoose.Schema(
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

    completed: {
      type: Boolean,
      default: false
    },

    correct: {
      type: Boolean,
      default: false
    },

    attempts: {
      type: Number,
      default: 0,
      min: 0
    },

    xpEarned: {
      type: Number,
      default: 0,
      min: 0
    },

    completedAt: {
      type: Date,
      default: null
    }
  },
  {
    timestamps: true
  }
);

userProgressSchema.index(
  { user: 1, minute: 1 },
  { unique: true }
);

module.exports = mongoose.model(
  "UserProgress",
  userProgressSchema
);