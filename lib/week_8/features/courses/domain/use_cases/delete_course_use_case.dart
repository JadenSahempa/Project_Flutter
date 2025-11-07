import '../repositories/course_repository.dart';

class DeleteCourseUseCase {
  final CourseRepository repo;
  DeleteCourseUseCase(this.repo);
  Future<void> call(String id) => repo.deleteCourse(id);
}
