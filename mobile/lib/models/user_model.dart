class UserModel {
  final String id;
  final String name;
  final String email;
  final List<String> interests;
  final String level;
  final int xp;
  final int streak;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.interests = const [],
    this.level = 'beginner',
    this.xp = 0,
    this.streak = 0,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      interests: List<String>.from(
        json['interests'] ?? [],
      ),
      level: json['level']?.toString() ?? 'beginner',
      xp: json['xp'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(
              json['createdAt'].toString(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'interests': interests,
      'level': level,
      'xp': xp,
      'streak': streak,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}