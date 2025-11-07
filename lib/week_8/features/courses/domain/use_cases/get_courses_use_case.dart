import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCoursesUseCase {
  final CourseRepository repo;
  GetCoursesUseCase(this.repo);
  Future<List<Course>> call() => repo.getCourses();
}
