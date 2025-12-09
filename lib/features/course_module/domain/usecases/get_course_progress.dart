import '../entities/course_progress_entity.dart';
import '../repositories/course_progress_repository.dart';

class GetCourseProgressUseCase {
  final CourseProgressRepository repository;

  GetCourseProgressUseCase(this.repository);

  Future<CourseProgressEntity?> call({
    required String userId,
    required String courseId,
  }) {
    return repository.getProgress(userId: userId, courseId: courseId);
  }
}
