import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/course_progress_entity.dart';
import '../../domain/repositories/course_progress_repository.dart';

class CourseProgressRepositoryFirestore implements CourseProgressRepository {
  final FirebaseFirestore firestore;

  CourseProgressRepositoryFirestore(this.firestore);

  DocumentReference<Map<String, dynamic>> _doc({
    required String userId,
    required String courseId,
  }) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('courseProgress')
        .doc(courseId);
  }

  @override
  Future<CourseProgressEntity?> getProgress({
    required String userId,
    required String courseId,
  }) async {
    final snap = await _doc(userId: userId, courseId: courseId).get();
    if (!snap.exists) return null;

    final data = snap.data() ?? {};

    final list =
        (data['completedLessonIds'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    return CourseProgressEntity(
      courseId: courseId,
      userId: userId,
      completedLessonIds: list,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  @override
  Future<CourseProgressEntity> toggleLessonCompleted({
    required String userId,
    required String courseId,
    required String lessonId,
  }) async {
    final ref = _doc(userId: userId, courseId: courseId);
    final now = DateTime.now();

    await firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);

      List<String> current = [];
      if (snap.exists) {
        final data = snap.data() ?? {};
        current =
            (data['completedLessonIds'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            <String>[];
      }

      if (current.contains(lessonId)) {
        current.remove(lessonId);
      } else {
        current.add(lessonId);
      }

      tx.set(ref, {
        'courseId': courseId,
        'userId': userId,
        'completedLessonIds': current,
        'updatedAt': Timestamp.fromDate(now),
      }, SetOptions(merge: true));
    });

    final newSnap = await ref.get();
    final data = newSnap.data() ?? {};
    final list =
        (data['completedLessonIds'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    return CourseProgressEntity(
      courseId: courseId,
      userId: userId,
      completedLessonIds: list,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
