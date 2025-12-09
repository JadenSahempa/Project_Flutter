import '../repositories/lesson_repository.dart';

class DeleteLessonUseCase {
  final LessonRepository repository;

  DeleteLessonUseCase(this.repository);

  Future<void> call({required String courseId, required String id}) {
    return repository.deleteLesson(courseId: courseId, id: id);
  }
}
