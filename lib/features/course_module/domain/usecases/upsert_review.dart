import '../repositories/review_repository.dart';

class UpsertReviewUseCase {
  final ReviewRepository repository;

  UpsertReviewUseCase(this.repository);

  Future<void> call({
    required String courseId,
    required String userId,
    required String userName,
    required double rating,
    required String comment,
  }) {
    return repository.upsertReview(
      courseId: courseId,
      userId: userId,
      userName: userName,
      rating: rating,
      comment: comment,
    );
  }
}
