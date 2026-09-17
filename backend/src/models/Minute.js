const mongoose = require("mongoose");

const questionSchema = new mongoose.Schema(
  {
    question: {
      type: String,
      required: true
    },

    options: {
      type: [String],
      required: true,
      validate: {
        validator: (value) => value.length >= 2,
        message: "A question must have at least two options"
      }
    },

    correctAnswer: {
      type: Number,
      required: true,
      min: 0
    },

    explanation: {
      type: String,
      default: ""
    }
  },
  {
    _id: false
  }
);

const minuteSchema = new mongoose.Schema(
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

    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Category",
      required: true
    },

    learningPath: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "LearningPath",
      required: true
    },

    level: {
      type: String,
      enum: ["beginner", "intermediate", "advanced"],
      required: true
    },

    order: {
      type: Number,
      required: true,
      min: 1
    },

    content: {
      type: String,
      required: true
    },

    keyTakeaway: {
      type: String,
      required: true
    },

    question: {
      type: questionSchema,
      required: true
    },

    xpReward: {
      type: Number,
      default: 10,
      min: 1
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

minuteSchema.index({
  learningPath: 1,
  order: 1
});

minuteSchema.index({
  category: 1,
  isPublished: 1
});

module.exports = mongoose.model("Minute", minuteSchema);