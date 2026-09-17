class MinuteModel {
  final String id;
  final String title;
  final String content;
  final String? summary;
  final String? pathId;
  final String? pathTitle;
  final int order;
  final int xpReward;
  final bool isCompleted;
  final String? question;
  final List<String> options;
  final int? correctAnswer;
  final String? explanation;

  const MinuteModel({
    required this.id,
    required this.title,
    required this.content,
    this.summary,
    this.pathId,
    this.pathTitle,
    this.order = 0,
    this.xpReward = 0,
    this.isCompleted = false,
    this.question,
    this.options = const [],
    this.correctAnswer,
    this.explanation,
  });

  factory MinuteModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final path = json['learningPath'];
    final questionData = json['question'];

    String? questionText;
    List<String> optionsList = const [];
    int? correctAnswerValue;
    String? explanationText;

    if (questionData is Map) {
      questionText = questionData['question']?.toString();
      optionsList = List<String>.from(
        questionData['options'] ?? [],
      );
      correctAnswerValue = questionData['correctAnswer'] as int?;
      explanationText = questionData['explanation']?.toString();
    } else if (questionData != null) {
      questionText = questionData.toString();
      optionsList = List<String>.from(
        json['options'] ?? [],
      );
    }

    return MinuteModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      summary: json['summary']?.toString(),
      pathId: path is Map
          ? path['_id']?.toString()
          : json['pathId']?.toString(),
      pathTitle: path is Map
          ? path['title']?.toString()
          : json['pathTitle']?.toString(),
      order: json['order'] as int? ?? 0,
      xpReward: json['xpReward'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      question: questionText,
      options: optionsList,
      correctAnswer: correctAnswerValue,
      explanation: explanationText,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'pathId': pathId,
      'pathTitle': pathTitle,
      'order': order,
      'xpReward': xpReward,
      'isCompleted': isCompleted,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }
}