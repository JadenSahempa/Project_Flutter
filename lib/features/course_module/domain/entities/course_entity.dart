class CourseEntity {
  final String id;
  final String name;
  final String price;
  final List<String> categoryTag;
  final String? thumbnail;
  final String? rating;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryTag,
    required this.thumbnail,
    required this.rating,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
}
