const express = require("express");

const {
  getRecallItems,
  answerRecall
} = require("../controllers/recallController");

const { protect } = require("../middlewares/authMiddleware");
const asyncHandler = require("../utils/asyncHandler");

const router = express.Router();

router.get(
  "/",
  protect,
  asyncHandler(getRecallItems)
);

router.post(
  "/:id/answer",
  protect,
  asyncHandler(answerRecall)
);

module.exports = router;