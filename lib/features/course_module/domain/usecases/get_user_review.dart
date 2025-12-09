import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class GetUserReviewUseCase {
  final ReviewRepository repository;

  GetUserReviewUseCase(this.repository);

  Future<ReviewEntity?> call({
    required String courseId,
    required String userId,
  }) {
    return repository.getUserReview(courseId: courseId, userId: userId);
  }
}
