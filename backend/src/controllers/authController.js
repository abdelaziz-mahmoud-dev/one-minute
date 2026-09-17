const bcrypt = require("bcryptjs");

const User = require("../models/User");
const Category = require("../models/Category");
const generateToken = require("../utils/generateToken");

const {
  validateRegister,
  validateLogin
} = require("../utils/validation");

const sanitizeUser = (user) => ({
  id: user._id,
  name: user.name,
  email: user.email,
  avatar: user.avatar,
  interests: user.interests,
  xp: user.xp,
  level: user.level,
  streak: user.streak
});

const register = async (req, res) => {
  const { name, email, password } = req.body;

  const validationErrors = validateRegister({
  name,
  email,
  password
});

if (validationErrors.length > 0) {
  return res.status(400).json({
    success: false,
    message: "Validation failed",
    errors: validationErrors
  });
}

  if (!name || !email || !password) {
    return res.status(400).json({
      success: false,
      message: "Name, email and password are required"
    });
  }

  const normalizedEmail = email.toLowerCase().trim();

  const existingUser = await User.findOne({
    email: normalizedEmail
  });

  if (existingUser) {
    return res.status(409).json({
      success: false,
      message: "An account with this email already exists"
    });
  }

  const hashedPassword = await bcrypt.hash(password, 12);

  const user = await User.create({
    name: name.trim(),
    email: normalizedEmail,
    password: hashedPassword
  });

  const token = generateToken(user._id.toString());

  res.status(201).json({
    success: true,
    message: "Account created successfully",
    data: {
      user: sanitizeUser(user),
      token
    }
  });
};

const login = async (req, res) => {
  const { email, password } = req.body;

  const validationErrors = validateLogin({
  email,
  password
});

if (validationErrors.length > 0) {
  return res.status(400).json({
    success: false,
    message: "Validation failed",
    errors: validationErrors
  });
}

  if (!email || !password) {
    return res.status(400).json({
      success: false,
      message: "Email and password are required"
    });
  }

  const user = await User.findOne({
    email: email.toLowerCase().trim()
  }).select("+password");

  if (!user) {
    return res.status(401).json({
      success: false,
      message: "Invalid email or password"
    });
  }

  const validPassword = await bcrypt.compare(
    password,
    user.password
  );

  if (!validPassword) {
    return res.status(401).json({
      success: false,
      message: "Invalid email or password"
    });
  }

  const token = generateToken(user._id.toString());

  res.status(200).json({
    success: true,
    message: "Login successful",
    data: {
      user: sanitizeUser(user),
      token
    }
  });
};

const getMe = async (req, res) => {
  const user = await User.findById(req.user._id)
    .populate("interests", "name slug icon");

  res.status(200).json({
    success: true,
    data: {
      user: sanitizeUser(user)
    }
  });
};

const updateProfile = async (req, res) => {
  const { name, avatar } = req.body;

  const updates = {};

  if (name !== undefined) {
    updates.name = name.trim();
  }

  if (avatar !== undefined) {
    updates.avatar = avatar;
  }

  const user = await User.findByIdAndUpdate(
    req.user._id,
    updates,
    {
      new: true,
      runValidators: true
    }
  ).populate("interests", "name slug icon");

  res.status(200).json({
    success: true,
    message: "Profile updated successfully",
    data: {
      user: sanitizeUser(user)
    }
  });
};

const updateInterests = async (req, res) => {
  const { interests } = req.body;

  if (!Array.isArray(interests)) {
    return res.status(400).json({
      success: false,
      message: "Interests must be an array"
    });
  }

  const categories = await Category.find({
    _id: { $in: interests },
    isActive: true
  });

  if (categories.length !== interests.length) {
    return res.status(400).json({
      success: false,
      message: "One or more interests are invalid"
    });
  }

  const user = await User.findByIdAndUpdate(
    req.user._id,
    { interests },
    { new: true }
  ).populate("interests", "name slug icon");

  res.status(200).json({
    success: true,
    message: "Interests updated successfully",
    data: {
      interests: user.interests
    }
  });
};

const changePassword = async (req, res) => {
  const { currentPassword, newPassword } = req.body;

  if (!currentPassword || !newPassword) {
    return res.status(400).json({
      success: false,
      message: "Current password and new password are required"
    });
  }

  const user = await User.findById(req.user._id).select("+password");

  const validPassword = await bcrypt.compare(
    currentPassword,
    user.password
  );

  if (!validPassword) {
    return res.status(401).json({
      success: false,
      message: "Current password is incorrect"
    });
  }

  user.password = await bcrypt.hash(newPassword, 12);

  await user.save();

  res.status(200).json({
    success: true,
    message: "Password changed successfully"
  });
};

module.exports = {
  register,
  login,
  getMe,
  updateProfile,
  updateInterests,
  changePassword
};