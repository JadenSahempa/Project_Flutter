import '../repositories/course_repository.dart';
import '../entities/course.dart';

class GetCourseById {
  final CourseRepository repo;
  GetCourseById(this.repo);
  Future<Course> call(String id) => repo.getById(id);
}
