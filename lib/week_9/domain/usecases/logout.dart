import 'package:luar_sekolah_lms/week_9/domain/repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
