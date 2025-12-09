import '../entities/enrollment_entity.dart';

abstract class EnrollmentRepository {
  Future<void> enroll({required String userId, required String courseId});

  Future<void> unenroll({required String userId, required String courseId});

  Future<List<EnrollmentEntity>> getUserEnrollments(String userId);

  Future<bool> isEnrolled({required String userId, required String courseId});
}
