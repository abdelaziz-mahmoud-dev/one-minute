class DashboardModel {
  final int totalXp;
  final int level;
  final int currentStreak;
  final int completedMinutes;
  final int dueRecalls;
  final int nextLevelXp;

  const DashboardModel({
    this.totalXp = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.completedMinutes = 0,
    this.dueRecalls = 0,
    this.nextLevelXp = 100,
  });

  factory DashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final user = json['user'];
    final stats = json['stats'];

    final userMap = user is Map
        ? Map<String, dynamic>.from(user)
        : <String, dynamic>{};

    final statsMap = stats is Map
        ? Map<String, dynamic>.from(stats)
        : <String, dynamic>{};

    return DashboardModel(
      totalXp: userMap['xp'] as int? ?? 0,
      level: userMap['level'] as int? ?? 1,
      currentStreak: userMap['streak'] as int? ?? 0,
      completedMinutes:
          statsMap['completedMinutes'] as int? ?? 0,
      dueRecalls: statsMap['dueRecalls'] as int? ?? 0,
      nextLevelXp: statsMap['nextLevelXp'] as int? ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalXp': totalXp,
      'level': level,
      'currentStreak': currentStreak,
      'completedMinutes': completedMinutes,
      'dueRecalls': dueRecalls,
      'nextLevelXp': nextLevelXp,
    };
  }
}