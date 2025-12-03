import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/user_profile_remote_data_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createUserProfile(UserProfileEntity user) {
    return remoteDataSource.createUserProfile(user);
  }

  @override
  Future<UserProfileEntity> getUserProfile(String uid) {
    return remoteDataSource.getUserProfile(uid);
  }
}
