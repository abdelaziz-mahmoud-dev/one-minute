class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final int pathCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.pathCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString(),
      icon: json['icon']?.toString(),
      pathCount: json['pathCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon': icon,
      'pathCount': pathCount,
    };
  }
}