import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class CreateCourseUseCase {
  final CourseRepository repository;

  CreateCourseUseCase(this.repository);

  /// Buat course baru.
  ///
  /// Catatan:
  /// - [status] untuk admin kita default 'draft'.
  /// - [createdBy] = uid admin (ambil dari FirebaseAuth.currentUser.uid di controller).
  Future<CourseEntity> call({
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
    String? description,
    String status = 'draft',
    required String createdBy,
  }) {
    return repository.createCourse(
      name: name,
      categoryTag: categoryTag,
      price: price,
      rating: rating,
      thumbnail: thumbnail,
      description: description,
      status: status,
      createdBy: createdBy,
    );
  }
}
