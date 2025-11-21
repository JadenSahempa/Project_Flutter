import 'package:luar_sekolah_lms/week_9/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> loginWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  AuthUser? getCurrentUser();
}
