import '../repositories/enrollment_repository.dart';

class UnenrollFromCourseUseCase {
  final EnrollmentRepository repository;

  UnenrollFromCourseUseCase(this.repository);

  Future<void> call({required String userId, required String courseId}) {
    return repository.unenroll(userId: userId, courseId: courseId);
  }
}
