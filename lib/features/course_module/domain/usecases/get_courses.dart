import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetCoursesUseCase {
  final CourseRepository repository;

  GetCoursesUseCase(this.repository);

  /// Ambil semua course (untuk admin).
  /// Nanti kalau mau filtering/paging, bisa extend dari sini.
  Future<List<CourseEntity>> call() {
    return repository.getCourses();
  }
}
