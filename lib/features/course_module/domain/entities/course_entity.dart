class CourseEntity {
  final String id;
  final String name;
  final String price;
  final List<String> categoryTag;
  final String? thumbnail;
  final String? rating;
  final String? description;
  final String status;
  final int enrollmentCount;
  final int reviewCount; // ⬅️ baru

  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryTag,
    required this.thumbnail,
    required this.rating,
    required this.description,
    required this.status,
    required this.enrollmentCount,
    this.reviewCount = 0, // ⬅️ default 0
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });
}
