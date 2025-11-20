import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetCourseDetailUseCase {
  final CourseRepository repository;

  GetCourseDetailUseCase(this.repository);

  Future<CourseEntity> call(String id) {
    return repository.getCourseById(id);
  }
}
