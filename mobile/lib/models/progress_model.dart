class ProgressModel {
  final String id;
  final String? minuteId;
  final String? minuteTitle;
  final bool completed;
  final bool correct;
  final int xpEarned;
  final int attempts;
  final DateTime? completedAt;

  const ProgressModel({
    required this.id,
    this.minuteId,
    this.minuteTitle,
    this.completed = false,
    this.correct = false,
    this.xpEarned = 0,
    this.attempts = 0,
    this.completedAt,
  });

  factory ProgressModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final minute = json['minute'];

    return ProgressModel(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          '',
      minuteId: minute is Map
          ? minute['_id']?.toString()
          : json['minuteId']?.toString(),
      minuteTitle: minute is Map
          ? minute['title']?.toString()
          : json['minuteTitle']?.toString(),
      completed: json['completed'] == true,
      correct: json['correct'] == true,
      xpEarned: _toInt(json['xpEarned']),
      attempts: _toInt(json['attempts']),
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(
              json['completedAt'].toString(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'minuteId': minuteId,
      'minuteTitle': minuteTitle,
      'completed': completed,
      'correct': correct,
      'xpEarned': xpEarned,
      'attempts': attempts,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}

class ProgressSummary {
  final int xp;
  final int level;
  final int streak;
  final int nextLevelXp;
  final int completedMinutes;

  const ProgressSummary({
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    this.nextLevelXp = 100,
    this.completedMinutes = 0,
  });

  factory ProgressSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProgressSummary(
      xp: _toInt(json['xp']),
      level: _toInt(json['level'], fallback: 1),
      streak: _toInt(json['streak']),
      nextLevelXp: _toInt(
        json['nextLevelXp'],
        fallback: 100,
      ),
      completedMinutes: _toInt(
        json['completedMinutes'],
      ),
    );
  }

  static int _toInt(
    dynamic value, {
    int fallback = 0,
  }) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        fallback;
  }
}

class ProgressPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const ProgressPagination({
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 0,
  });

  factory ProgressPagination.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProgressPagination(
      page: _toInt(json['page'], fallback: 1),
      limit: _toInt(json['limit'], fallback: 20),
      total: _toInt(json['total']),
      totalPages: _toInt(json['totalPages']),
    );
  }

  static int _toInt(
    dynamic value, {
    int fallback = 0,
  }) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        fallback;
  }
}