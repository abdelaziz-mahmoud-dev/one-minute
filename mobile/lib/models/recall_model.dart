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

    Map<String, dynamic>? minuteData;

    if (minute is Map) {
      minuteData = Map<String, dynamic>.from(minute);
    }

    final questionData = minuteData?['question'];

    Map<String, dynamic>? question;

    if (questionData is Map) {
      question = Map<String, dynamic>.from(questionData);
    }

    final rawOptions = question?['options'];

    return RecallModel(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          '',
      minuteId: minuteData?['_id']?.toString() ??
          json['minuteId']?.toString(),
      minuteTitle: minuteData?['title']?.toString() ??
          json['minuteTitle']?.toString(),
      question: question?['question']?.toString() ??
          json['question']?.toString() ??
          '',
      options: rawOptions is List
          ? rawOptions
              .map((option) => option.toString())
              .toList()
          : const [],
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