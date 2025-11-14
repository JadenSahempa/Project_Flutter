import 'package:luar_sekolah_lms/week_9/domain/entities/auth_user.dart';
import 'package:luar_sekolah_lms/week_9/data/datasources/firebase_auth_datasource.dart';
import 'package:luar_sekolah_lms/week_9/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  AuthUser _mapUser(user) {
    return AuthUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  @override
  AuthUser? getCurrentUser() {
    // TODO: implement getCurrentUser
    final user = dataSource.getCurrentUser();
    if (user == null) return null;
    return _mapUser(user);
    // throw UnimplementedError();
  }

  @override
  Future<AuthUser> loginWithEmail({
    required String email,
    required String password,
  }) async {
    // TODO: implement loginWithEmail
    final user = await dataSource.loginWithEmail(
      email: email,
      password: password,
    );
    return _mapUser(user);
    // throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    return dataSource.logout();
    // throw UnimplementedError();
  }

  @override
  Future<AuthUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    // TODO: implement registerWithEmail
    final user = await dataSource.registerWithEmail(
      name: name,
      email: email,
      password: password,
    );
    return _mapUser(user);
    // throw UnimplementedError();
  }
}
