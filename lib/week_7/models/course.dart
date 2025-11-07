class Course {
  final String id;
  final String name;
  final String price;
  final List<String> categoryTag;
  final String? thumbnail;
  final String? rating;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
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

  factory Course.fromJson(Map<String, dynamic> j) => Course(
    id: j['id'] as String,
    name: j['name'] as String? ?? '',
    price: j['price'] as String? ?? '0.00',
    categoryTag:
        (j['categoryTag'] as List?)?.map((e) => e.toString()).toList() ??
        const [],
    thumbnail: j['thumbnail'] as String?,
    rating: j['rating']?.toString(),
    createdBy: j['createdBy'] as String? ?? '',
    createdAt:
        DateTime.tryParse(j['createdAt'] ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt:
        DateTime.tryParse(j['updatedAt'] ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
  );
}
