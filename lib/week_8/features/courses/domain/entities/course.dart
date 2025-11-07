class Course {
  final String id;
  final String name;
  final double price;
  final List<String> categoryTag;
  final String? thumbnail;
  final double? rating;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Course({
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
}
