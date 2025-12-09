import '../repositories/enrollment_repository.dart';

class IsUserEnrolledUseCase {
  final EnrollmentRepository repository;

  IsUserEnrolledUseCase(this.repository);

  Future<bool> call({required String userId, required String courseId}) {
    return repository.isEnrolled(userId: userId, courseId: courseId);
  }
}
