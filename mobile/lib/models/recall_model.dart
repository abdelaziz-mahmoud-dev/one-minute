class RecallModel {
  final String id;
  final String? minuteId;
  final String? minuteTitle;
  final String question;
  final List<String> options;
  final DateTime? dueAt;

  const RecallModel({
    required this.id,
    required this.question,
    this.minuteId,
    this.minuteTitle,
    this.options = const [],
    this.dueAt,
  });

  factory RecallModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final minute = json['minute'];

    return RecallModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      minuteId: minute is Map
          ? minute['_id']?.toString()
          : json['minuteId']?.toString(),
      minuteTitle: minute is Map
          ? minute['title']?.toString()
          : json['minuteTitle']?.toString(),
      question: json['question']?.toString() ?? '',
      options: List<String>.from(
        json['options'] ?? [],
      ),
      dueAt: json['dueAt'] != null
          ? DateTime.tryParse(
              json['dueAt'].toString(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'minuteId': minuteId,
      'minuteTitle': minuteTitle,
      'question': question,
      'options': options,
      'dueAt': dueAt?.toIso8601String(),
    };
  }
}