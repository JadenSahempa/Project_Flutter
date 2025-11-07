import '../../domain/entities/course.dart';

class CourseModel {
  final String id;
  final String name;
  final double price;
  final List<String> categoryTag;
  final String? thumbnail;
  final double? rating;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseModel({
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

  factory CourseModel.fromEntity(Course e) => CourseModel(
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

  factory CourseModel.fromJson(Map<String, dynamic> j) {
    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return CourseModel(
      id: '${j['id']}',
      name: j['name'] ?? '',
      price: parseDouble(j['price']), // "0.00" -> 0.0
      categoryTag:
          (j['categoryTag'] as List?)?.map((e) => '$e').toList() ?? const [],
      thumbnail: j['thumbnail'],
      rating: j['rating'] != null ? parseDouble(j['rating']) : null,
      createdBy: '${j['createdBy'] ?? ''}',
      createdAt:
          DateTime.tryParse('${j['createdAt']}') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse('${j['updatedAt']}') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    // kirim sebagai string 2 desimal bila backend mengharapkan string
    'price': price.toStringAsFixed(2),
    'categoryTag': categoryTag,
    if (thumbnail != null) 'thumbnail': thumbnail,
    if (rating != null) 'rating': rating!.toStringAsFixed(1),
    'createdBy': createdBy,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
