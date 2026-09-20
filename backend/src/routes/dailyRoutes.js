const express = require("express");

const {
  getDailyMinute
} = require("../controllers/dailyController");

const { protect } = require("../middlewares/authMiddleware");
const asyncHandler = require("../utils/asyncHandler");

const router = express.Router();

router.get(
  "/",
  protect,
  asyncHandler(getDailyMinute)
);

module.exports = router;