const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      minlength: 2,
      maxlength: 50
    },

    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true
    },

    password: {
      type: String,
      required: true,
      minlength: 6,
      select: false
    },

    avatar: {
      type: String,
      default: null
    },

    interests: {
      type: [
        {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Category"
        }
      ],
      default: []
    },

    xp: {
      type: Number,
      default: 0,
      min: 0
    },

    level: {
      type: Number,
      default: 1,
      min: 1
    },

    streak: {
      type: Number,
      default: 0,
      min: 0
    },

    lastActiveDate: {
      type: Date,
      default: null
    }
  },
  {
    timestamps: true
  }
);

userSchema.index({
  email: 1
});

module.exports = mongoose.model("User", userSchema);