class ProgressModel {
  final String id;
  final String? minuteId;
  final String? minuteTitle;
  final bool completed;
  final bool correct;
  final int attempts;
  final int xpEarned;
  final DateTime? completedAt;

  const ProgressModel({
    required this.id,
    this.minuteId,
    this.minuteTitle,
    this.completed = false,
    this.correct = false,
    this.attempts = 0,
    this.xpEarned = 0,
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
      attempts: json['attempts'] is num
          ? (json['attempts'] as num).toInt()
          : 0,
      xpEarned: json['xpEarned'] is num
          ? (json['xpEarned'] as num).toInt()
          : 0,
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
      'attempts': attempts,
      'xpEarned': xpEarned,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}