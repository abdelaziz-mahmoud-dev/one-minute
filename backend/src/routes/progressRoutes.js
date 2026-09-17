const express = require("express");

const {
  getProgress,
  getMyProgress,
  answerMinute
} = require("../controllers/progressController");

const { protect } = require("../middlewares/authMiddleware");
const asyncHandler = require("../utils/asyncHandler");

const router = express.Router();

router.get(
  "/",
  protect,
  asyncHandler(getProgress)
);

router.get(
  "/completed",
  protect,
  asyncHandler(getMyProgress)
);

router.post(
  "/minutes/:id/answer",
  protect,
  asyncHandler(answerMinute)
);

module.exports = router;