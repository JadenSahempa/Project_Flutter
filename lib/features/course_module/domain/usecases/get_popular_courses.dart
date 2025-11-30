import '../repositories/course_repository.dart';

class GetPopularCoursesUseCase {
  final CourseRepository repository;

  GetPopularCoursesUseCase(this.repository);

  Future<CoursePage> call({
    required int limit,
    required int offset,
    List<String>? categoryTag,
  }) {
    return repository.getCourses(
      limit: limit,
      offset: offset,
      categoryTag: categoryTag,
    );
  }
}
