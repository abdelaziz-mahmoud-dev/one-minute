const calculateLevel = (xp) => {
  return Math.floor(xp / 100) + 1;
};

const getNextLevelXp = (level) => {
  return level * 100;
};

const isSameDay = (firstDate, secondDate) => {
  return (
    firstDate.getFullYear() === secondDate.getFullYear() &&
    firstDate.getMonth() === secondDate.getMonth() &&
    firstDate.getDate() === secondDate.getDate()
  );
};

const isYesterday = (date) => {
  const yesterday = new Date();

  yesterday.setDate(yesterday.getDate() - 1);

  return isSameDay(date, yesterday);
};

const updateStreak = (user) => {
  const now = new Date();

  if (!user.lastActiveDate) {
    user.streak = 1;
  } else if (isSameDay(user.lastActiveDate, now)) {
    return;
  } else if (isYesterday(user.lastActiveDate)) {
    user.streak += 1;
  } else {
    user.streak = 1;
  }

  user.lastActiveDate = now;
};

module.exports = {
  calculateLevel,
  getNextLevelXp,
  updateStreak
};