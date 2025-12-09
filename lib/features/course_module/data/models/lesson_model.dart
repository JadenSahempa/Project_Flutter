import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/lesson_entity.dart';

class LessonModel extends LessonEntity {
  LessonModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.content,
    required super.order,
    // required super.isPreview,
    // required super.createdAt,
    // required super.updatedAt,
  });

  factory LessonModel.fromDoc(
    String courseId,
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return LessonModel(
      id: doc.id,
      courseId: courseId,
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      order: (data['order'] as num?)?.toInt() ?? 0,
      // isPreview: data['isPreview'] as bool? ?? false,
      // createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      // updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'order': order,
      // 'isPreview': isPreview,
      // 'createdAt': Timestamp.fromDate(createdAt),
      // 'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
