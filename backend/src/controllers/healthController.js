const getHealth = (req, res) => {
  res.status(200).json({
    success: true,
    message: "One Minute API is healthy",
    timestamp: new Date().toISOString()
  });
};

module.exports = {
  getHealth
};