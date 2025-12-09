import '../entities/lesson_entity.dart';
import '../repositories/lesson_repository.dart';

class UpdateLessonUseCase {
  final LessonRepository repository;

  UpdateLessonUseCase(this.repository);

  Future<LessonEntity> call({
    required String courseId,
    required String id,
    required String title,
    required String content,
    required int order,
  }) {
    return repository.updateLesson(
      courseId: courseId,
      id: id,
      title: title,
      content: content,
      order: order,
    );
  }
}
