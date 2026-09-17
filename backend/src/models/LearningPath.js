const mongoose = require("mongoose");

const learningPathSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
      trim: true
    },

    slug: {
      type: String,
      required: true,
      unique: true,
      lowercase: true
    },

    description: {
      type: String,
      required: true
    },

    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Category",
      required: true
    },

    level: {
      type: String,
      enum: ["beginner", "intermediate", "advanced"],
      required: true
    },

    estimatedMinutes: {
      type: Number,
      default: 0,
      min: 0
    },

    isPublished: {
      type: Boolean,
      default: false
    }
  },
  {
    timestamps: true
  }
);

learningPathSchema.index({
  category: 1,
  level: 1,
  isPublished: 1
});

module.exports = mongoose.model(
  "LearningPath",
  learningPathSchema
);