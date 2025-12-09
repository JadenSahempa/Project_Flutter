import '../../domain/entities/course_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel extends CourseEntity {
  CourseModel({
    required super.id,
    required super.name,
    required super.price,
    required super.categoryTag,
    required super.thumbnail,
    required super.rating,
    required super.description,
    required super.status,
    required super.enrollmentCount,
    super.reviewCount, // ⬅️ boleh null → default di entity = 0
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CourseModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return CourseModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      price: data['price'] as String? ?? '0.00',
      categoryTag:
          (data['categoryTag'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      thumbnail: data['thumbnail'] as String?,
      rating: data['rating']?.toString(), // bisa null / double / string
      description: data['description'] as String? ?? '',
      status: data['status'] as String? ?? 'draft',
      enrollmentCount: (data['enrollmentCount'] as num?)?.toInt() ?? 0,
      reviewCount:
          (data['reviewCount'] as num?)?.toInt() ??
          0, // ⬅️ PAKAI data, BUKAN map
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'categoryTag': categoryTag,
      'thumbnail': thumbnail,
      'rating': rating,
      'description': description,
      'status': status,
      'enrollmentCount': enrollmentCount,
      'reviewCount': reviewCount, // ⬅️ baru
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
