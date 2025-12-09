class EnrollmentEntity {
  final String id;
  final String courseId;
  final String userId;
  final DateTime enrolledAt;

  const EnrollmentEntity({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.enrolledAt,
  });
}
