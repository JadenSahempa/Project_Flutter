import 'package:luar_sekolah_lms/week_9/domain/entities/auth_user.dart';
import 'package:luar_sekolah_lms/week_9/domain/repositories/auth_repository.dart';

class LoginWithEmail {
  final AuthRepository repository;

  LoginWithEmail(this.repository);

  Future<AuthUser> call({required String email, required String password}) {
    return repository.loginWithEmail(email: email, password: password);
  }
}
