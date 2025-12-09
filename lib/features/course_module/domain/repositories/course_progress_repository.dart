import '../entities/course_progress_entity.dart';

abstract class CourseProgressRepository {
  Future<CourseProgressEntity?> getProgress({
    required String userId,
    required String courseId,
  });

  /// Toggle selesai/belum untuk satu lesson.
  Future<CourseProgressEntity> toggleLessonCompleted({
    required String userId,
    required String courseId,
    required String lessonId,
  });
}
