import '../repositories/course_repository.dart';

class DeleteCourse {
  final CourseRepository repo;
  DeleteCourse(this.repo);
  Future<void> call(String id) => repo.delete(id);
}
