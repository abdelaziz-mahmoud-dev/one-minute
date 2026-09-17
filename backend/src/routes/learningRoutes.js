const express = require("express");

const {
  getCategories,
  getLearningPaths,
  getLearningPath,
  getMinute
} = require("../controllers/learningController");

const asyncHandler = require("../utils/asyncHandler");

const router = express.Router();

router.get(
  "/categories",
  asyncHandler(getCategories)
);

router.get(
  "/paths",
  asyncHandler(getLearningPaths)
);

router.get(
  "/paths/:id",
  asyncHandler(getLearningPath)
);

router.get(
  "/minutes/:id",
  asyncHandler(getMinute)
);

module.exports = router;