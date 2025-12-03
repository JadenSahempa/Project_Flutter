import 'package:luar_sekolah_lms/features/auth_module/domain/entities/auth_user.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/repositories/auth_repository.dart';

class RegisterWithEmail {
  final AuthRepository repository;

  RegisterWithEmail(this.repository);

  Future<AuthUser> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.registerWithEmail(
      name: name,
      email: email,
      password: password,
    );
  }
}
