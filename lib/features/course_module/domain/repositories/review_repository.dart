import '../entities/review_entity.dart';

abstract class ReviewRepository {
  Future<List<ReviewEntity>> getReviews(String courseId);

  /// Ambil review khusus milik user (kalau ada)
  Future<ReviewEntity?> getUserReview({
    required String courseId,
    required String userId,
  });

  /// Upsert = create/update review user untuk course ini
  Future<void> upsertReview({
    required String courseId,
    required String userId,
    required String userName,
    required double rating,
    required String comment,
  });

  Future<void> deleteReview({required String courseId, required String userId});
}
