import '../repositories/course_repository.dart';

class DeleteCourseUseCase {
  final CourseRepository repository;

  DeleteCourseUseCase(this.repository);

  /// Hapus course berdasarkan [id].
  Future<void> call(String id) {
    return repository.deleteCourse(id);
  }
}
