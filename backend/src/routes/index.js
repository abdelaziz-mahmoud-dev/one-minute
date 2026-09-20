const express = require("express");

const authRoutes = require("./authRoutes");
const healthRoutes = require("./healthRoutes");
const learningRoutes = require("./learningRoutes");
const progressRoutes = require("./progressRoutes");
const recallRoutes = require("./recallRoutes");
const dailyRoutes = require("./dailyRoutes");
const dashboardRoutes = require("./dashboardRoutes");

const router = express.Router();

router.use("/health", healthRoutes);
router.use("/auth", authRoutes);
router.use("/learning", learningRoutes);
router.use("/progress", progressRoutes);
router.use("/recall", recallRoutes);
router.use("/daily", dailyRoutes);
router.use("/dashboard", dashboardRoutes);

module.exports = router;