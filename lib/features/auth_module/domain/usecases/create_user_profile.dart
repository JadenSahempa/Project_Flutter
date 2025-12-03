import '../entities/user_profile_entity.dart';
import '../repositories/user_profile_repository.dart';

class CreateUserProfileUseCase {
  final UserProfileRepository repository;

  CreateUserProfileUseCase(this.repository);

  Future<void> call(UserProfileEntity user) {
    return repository.createUserProfile(user);
  }
}
