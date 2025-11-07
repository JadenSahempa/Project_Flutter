import '../entities/course.dart';
import '../repositories/course_repository.dart';

class CreateCourseUseCase {
  final CourseRepository repo;
  CreateCourseUseCase(this.repo);

  Future<Course> call({
    required String title,
    required int price,
    required String category,
  }) {
    if (title.trim().isEmpty) throw Exception('Nama wajib diisi');
    if (price <= 0) throw Exception('Harga harus > 0');
    if (category.isEmpty) throw Exception('Kategori wajib diisi');
    return repo.createCourse(
      title: title.trim(),
      price: price,
      category: category,
    );
  }
}
