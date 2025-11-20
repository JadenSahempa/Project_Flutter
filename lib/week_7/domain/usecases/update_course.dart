import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class UpdateCourseUseCase {
  final CourseRepository repository;

  UpdateCourseUseCase(this.repository);

  Future<CourseEntity> call({
    required String id,
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
  }) {
    return repository.updateCourse(
      id: id,
      name: name,
      categoryTag: categoryTag,
      price: price,
      rating: rating,
      thumbnail: thumbnail,
    );
  }
}
