const calculateNextRecall = (score, currentInterval) => {
  if (score <= 1) {
    return 1;
  }

  if (score === 2) {
    return Math.max(1, Math.floor(currentInterval / 2));
  }

  if (score === 3) {
    return Math.max(2, currentInterval);
  }

  if (score === 4) {
    return Math.max(3, currentInterval * 2);
  }

  return Math.max(5, currentInterval * 3);
};

const getNextReviewDate = (intervalDays) => {
  const nextDate = new Date();

  nextDate.setDate(
    nextDate.getDate() + intervalDays
  );

  return nextDate;
};

module.exports = {
  calculateNextRecall,
  getNextReviewDate
};