import '../entities/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<void> createUserProfile(UserProfileEntity user);
  Future<UserProfileEntity> getUserProfile(String uid);
}
