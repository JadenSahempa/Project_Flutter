import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class UpdateCourseUseCase {
  final CourseRepository repository;

  UpdateCourseUseCase(this.repository);

  /// Update course yang sudah ada.
  ///
  /// [status] bisa diubah (draft/published/maintenance).
  /// Field lain seperti [description], [thumbnail], [rating] bisa null:
  ///   - Kalau null: berarti "tidak diubah" (kita handle di repository).
  Future<CourseEntity> call({
    required String id,
    required String name,
    required List<String> categoryTag,
    String? price,
    String? rating,
    String? thumbnail,
    String? description,
    String? status,
  }) {
    return repository.updateCourse(
      id: id,
      name: name,
      categoryTag: categoryTag,
      price: price,
      rating: rating,
      thumbnail: thumbnail,
      description: description,
      status: status,
    );
  }
}
