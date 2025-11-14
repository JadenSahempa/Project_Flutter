class Course {
  final String id;
  final String name;
  final String price; // simpan sebagai string sesuai API saat ini
  final List<String> categoryTag;
  final String? thumbnail;
  final String? rating;
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
