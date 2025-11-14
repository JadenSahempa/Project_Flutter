import '../repositories/course_repository.dart';
import '../entities/course.dart';

class CreateCourse {
  final CourseRepository repo;
  CreateCourse(this.repo);

  Future<Course> call({
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
  }) => repo.create(
    name: name,
    categoryTag: categoryTag,
    price: price,
    rating: rating,
    thumbnail: thumbnail,
  );
}
