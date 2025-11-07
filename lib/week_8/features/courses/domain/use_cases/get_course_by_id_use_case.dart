import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCourseByIdUseCase {
  final CourseRepository repo;
  GetCourseByIdUseCase(this.repo);

  Future<Course> call(String id) => repo.getCourseById(id);
}
