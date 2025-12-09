import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class GetReviewsUseCase {
  final ReviewRepository repository;

  GetReviewsUseCase(this.repository);

  Future<List<ReviewEntity>> call(String courseId) {
    return repository.getReviews(courseId);
  }
}
