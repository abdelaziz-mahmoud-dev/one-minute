const express = require("express");

const {
  register,
  login,
  getMe,
  updateProfile,
  updateInterests,
  changePassword
} = require("../controllers/authController");

const {
  protect
} = require("../middlewares/authMiddleware");

const {
  authLimiter
} = require("../middlewares/rateLimiter");

const asyncHandler = require("../utils/asyncHandler");

const router = express.Router();

router.post(
  "/register",
  authLimiter,
  asyncHandler(register)
);

router.post(
  "/login",
  authLimiter,
  asyncHandler(login)
);

router.get(
  "/me",
  protect,
  asyncHandler(getMe)
);

router.patch(
  "/profile",
  protect,
  asyncHandler(updateProfile)
);

router.patch(
  "/interests",
  protect,
  asyncHandler(updateInterests)
);

router.patch(
  "/password",
  protect,
  asyncHandler(changePassword)
);

module.exports = router;