import '../entities/enrollment_entity.dart';
import '../repositories/enrollment_repository.dart';

class GetUserEnrollmentsUseCase {
  final EnrollmentRepository repository;

  GetUserEnrollmentsUseCase(this.repository);

  Future<List<EnrollmentEntity>> call(String userId) {
    return repository.getUserEnrollments(userId);
  }
}
