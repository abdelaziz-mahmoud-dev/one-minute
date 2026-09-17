import 'minute_model.dart';

class LearningPathModel {
  final String id;
  final String title;
  final String slug;
  final String? description;
  final String? level;
  final String? categoryId;
  final String? categoryName;
  final int minuteCount;
  final int completedMinutes;
  final List<MinuteModel> minutes;

  const LearningPathModel({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    this.level,
    this.categoryId,
    this.categoryName,
    this.minuteCount = 0,
    this.completedMinutes = 0,
    this.minutes = const [],
  });

  factory LearningPathModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final category = json['category'];

    final minutesJson = json['minutes'];
    final minutesList = minutesJson is List
        ? minutesJson
            .whereType<Map>()
            .map((m) => MinuteModel.fromJson(
                  Map<String, dynamic>.from(m),
                ))
            .toList()
        : <MinuteModel>[];

    return LearningPathModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      level: json['level']?.toString(),
      categoryId: category is Map
          ? category['_id']?.toString()
          : json['categoryId']?.toString(),
      categoryName: category is Map
          ? category['name']?.toString()
          : json['categoryName']?.toString(),
      minuteCount: json['minuteCount'] as int? ??
          json['estimatedMinutes'] as int? ??
          minutesList.length,
      completedMinutes:
          json['completedMinutes'] as int? ?? 0,
      minutes: minutesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'level': level,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'minuteCount': minuteCount,
      'completedMinutes': completedMinutes,
    };
  }
}