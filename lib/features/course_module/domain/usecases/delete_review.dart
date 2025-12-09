import '../repositories/review_repository.dart';

class DeleteReviewUseCase {
  final ReviewRepository repository;

  DeleteReviewUseCase(this.repository);

  Future<void> call({required String courseId, required String userId}) {
    return repository.deleteReview(courseId: courseId, userId: userId);
  }
}
