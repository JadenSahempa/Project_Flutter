import '../../domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  CourseModel({
    required super.id,
    required super.name,
    required super.price,
    required super.categoryTag,
    required super.thumbnail,
    required super.rating,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> j) {
    return CourseModel(
      id: j['id'] as String,
      name: j['name'] as String? ?? '',
      price: j['price'] as String? ?? '0.00',
      categoryTag:
          (j['categoryTag'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      thumbnail: j['thumbnail'] as String?,
      rating: j['rating']?.toString(),
      createdBy: j['createdBy'] as String? ?? '',
      createdAt: DateTime.tryParse(j['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(j['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'categoryTag': categoryTag,
      'thumbnail': thumbnail,
      'rating': rating,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
