import '../entities/course.dart';
import '../repositories/course_repository.dart';

class UpdateCourseUseCase {
  final CourseRepository repo;
  UpdateCourseUseCase(this.repo);

  Future<Course> call({
    required String id,
    required String title,
    required int price,
    required String category,
  }) {
    if (title.trim().isEmpty) throw Exception('Nama wajib diisi');
    if (price <= 0) throw Exception('Harga harus > 0');
    if (category.isEmpty) throw Exception('Kategori wajib diisi');
    return repo.updateCourse(
      id: id,
      title: title.trim(),
      price: price,
      category: category,
    );
  }
}
