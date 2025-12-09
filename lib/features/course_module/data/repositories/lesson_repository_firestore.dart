import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../models/lesson_model.dart';

class LessonRepositoryFirestore implements LessonRepository {
  final FirebaseFirestore firestore;

  LessonRepositoryFirestore(this.firestore);

  CollectionReference<Map<String, dynamic>> _lessonsCol(String courseId) {
    return firestore.collection('courses').doc(courseId).collection('lessons');
  }

  @override
  Future<List<LessonEntity>> getLessons(String courseId) async {
    final snap = await _lessonsCol(courseId).orderBy('order').get();

    return snap.docs.map((d) => LessonModel.fromDoc(courseId, d)).toList();
  }

  @override
  Future<LessonEntity> createLesson({
    required String courseId,
    required String title,
    required String content,
    required int order,
  }) async {
    final model = LessonModel(
      id: '',
      courseId: courseId,
      title: title,
      content: content,
      order: order,
    );

    final ref = await _lessonsCol(courseId).add(model.toMap());
    final createdDoc = await ref.get();

    return LessonModel.fromDoc(courseId, createdDoc);
  }

  @override
  Future<LessonEntity> updateLesson({
    required String id,
    required String courseId,
    required String title,
    required String content,
    required int order,
  }) async {
    final map = {'title': title, 'content': content, 'order': order};

    final ref = _lessonsCol(courseId).doc(id);
    await ref.update(map);
    final updatedDoc = await ref.get();

    return LessonModel.fromDoc(courseId, updatedDoc);
  }

  @override
  Future<void> deleteLesson({
    required String id,
    required String courseId,
  }) async {
    await _lessonsCol(courseId).doc(id).delete();
  }
}
