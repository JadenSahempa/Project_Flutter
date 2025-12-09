class ReviewEntity {
  final String id;
  final String courseId;
  final String userId;
  final int rating;
  final String comment;
  final String? userName;
  final String? userAvatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReviewEntity({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.rating,
    required this.comment,
    this.userName,
    this.userAvatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}
