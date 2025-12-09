import '../entities/course_progress_entity.dart';
import '../repositories/course_progress_repository.dart';

class ToggleLessonCompletedUseCase {
  final CourseProgressRepository repository;

  ToggleLessonCompletedUseCase(this.repository);

  Future<CourseProgressEntity> call({
    required String userId,
    required String courseId,
    required String lessonId,
  }) {
    return repository.toggleLessonCompleted(
      userId: userId,
      courseId: courseId,
      lessonId: lessonId,
    );
  }
}
