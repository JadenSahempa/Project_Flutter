import '../repositories/enrollment_repository.dart';

class EnrollInCourseUseCase {
  final EnrollmentRepository repository;

  EnrollInCourseUseCase(this.repository);

  Future<void> call({required String userId, required String courseId}) {
    return repository.enroll(userId: userId, courseId: courseId);
  }
}
