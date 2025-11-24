import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class CreateCourseUseCase {
  final CourseRepository repository;

  CreateCourseUseCase(this.repository);

  Future<CourseEntity> call({
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
  }) {
    return repository.createCourse(
      name: name,
      categoryTag: categoryTag,
      price: price,
      rating: rating,
      thumbnail: thumbnail,
    );
  }
}
