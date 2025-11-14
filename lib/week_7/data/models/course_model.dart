import '../../domain/entities/course.dart';

class CourseModel {
  final String id;
  final String name;
  final String price;
  final List<String> categoryTag;
  final String? thumbnail;
  final String? rating;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseModel({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryTag,
    this.thumbnail,
    this.rating,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> j) => CourseModel(
    id: j['id'].toString(),
    name: j['name']?.toString() ?? '',
    price: j['price']?.toString() ?? '0.00',
    categoryTag:
        (j['categoryTag'] as List?)?.map((e) => e.toString()).toList() ??
        const [],
    thumbnail: j['thumbnail'] as String?,
    rating: j['rating']?.toString(),
    createdBy: j['createdBy']?.toString() ?? '',
    createdAt:
        DateTime.tryParse(j['createdAt'] ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt:
        DateTime.tryParse(j['updatedAt'] ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'categoryTag': categoryTag,
    if (thumbnail != null) 'thumbnail': thumbnail,
    if (rating != null) 'rating': rating,
    'createdBy': createdBy,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  Course toEntity() => Course(
    id: id,
    name: name,
    price: price,
    categoryTag: categoryTag,
    thumbnail: thumbnail,
    rating: rating,
    createdBy: createdBy,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  static CourseModel fromEntity(Course e) => CourseModel(
    id: e.id,
    name: e.name,
    price: e.price,
    categoryTag: e.categoryTag,
    thumbnail: e.thumbnail,
    rating: e.rating,
    createdBy: e.createdBy,
    createdAt: e.createdAt,
    updatedAt: e.updatedAt,
  );
}
