const express = require("express");

const {
  getDashboard
} = require("../controllers/dashboardController");

const { protect } = require("../middlewares/authMiddleware");
const asyncHandler = require("../utils/asyncHandler");

const router = express.Router();

router.get(
  "/",
  protect,
  asyncHandler(getDashboard)
);

module.exports = router;