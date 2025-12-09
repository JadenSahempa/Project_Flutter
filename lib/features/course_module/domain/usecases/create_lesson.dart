import '../entities/lesson_entity.dart';
import '../repositories/lesson_repository.dart';

class CreateLessonUseCase {
  final LessonRepository repository;

  CreateLessonUseCase(this.repository);

  Future<LessonEntity> call({
    required String courseId,
    required String title,
    required String content,
    required int order,
  }) {
    return repository.createLesson(
      courseId: courseId,
      title: title,
      content: content,
      order: order,
    );
  }
}
