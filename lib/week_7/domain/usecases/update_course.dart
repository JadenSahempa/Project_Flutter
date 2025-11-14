import '../repositories/course_repository.dart';
import '../entities/course.dart';

class UpdateCourse {
  final CourseRepository repo;
  UpdateCourse(this.repo);

  Future<Course> call({
    required String id,
    required String name,
    required List<String> categoryTag,
    required String price,
    String? rating,
    String? thumbnail,
  }) => repo.update(
    id: id,
    name: name,
    categoryTag: categoryTag,
    price: price,
    rating: rating,
    thumbnail: thumbnail,
  );
}
