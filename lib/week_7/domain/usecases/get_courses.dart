import '../repositories/course_repository.dart';
import '../entities/course.dart';

class GetCourses {
  final CourseRepository repo;
  GetCourses(this.repo);

  Future<({List<Course> courses, int total, int limit, int offset})> call({
    required int limit,
    required int offset,
    List<String> categoryTag = const [],
  }) => repo.fetch(limit: limit, offset: offset, categoryTag: categoryTag);
}
