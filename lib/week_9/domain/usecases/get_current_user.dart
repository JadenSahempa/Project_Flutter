import 'package:luar_sekolah_lms/week_9/domain/entities/auth_user.dart';
import 'package:luar_sekolah_lms/week_9/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  AuthUser? call() {
    return repository.getCurrentUser();
  }
}
