import 'package:get/get.dart';
import 'package:luar_sekolah_lms/week_9/domain/entities/auth_user.dart';
import 'package:luar_sekolah_lms/week_9/domain/usecases/get_current_user.dart';
import 'package:luar_sekolah_lms/week_9/domain/usecases/login_with_email.dart';
import 'package:luar_sekolah_lms/week_9/domain/usecases/logout.dart';
import 'package:luar_sekolah_lms/week_9/domain/usecases/register_with_email.dart';

class AuthController extends GetxController {
  final LoginWithEmail loginWithEmail;
  final RegisterWithEmail registerWithEmail;
  final Logout logoutUseCase;
  final GetCurrentUser getCurrentUser;

  AuthController({
    required this.loginWithEmail,
    required this.registerWithEmail,
    required this.logoutUseCase,
    required this.getCurrentUser,
  });

  // State user
  final Rxn<AuthUser> currentUser = Rxn<AuthUser>();

  // Loading States
  final RxBool isLoginLoading = false.obs;
  final RxBool isRegisterLoading = false.obs;

  // UI states for login
  final RxBool obscureLoginPassword = true.obs;
  final RxBool isHumanCheckedLogin = false.obs;

  // UI states for Register
  final RxBool obscureRegisterPassword = true.obs;
  final RxBool isHumanCheckedRegister = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = getCurrentUser();
  }

  Future<void> login({required String email, required String password}) async {
    isLoginLoading.value = true;
    try {
      final user = await loginWithEmail(email: email, password: password);
      currentUser.value = user;
    } finally {
      isLoginLoading.value = false;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isRegisterLoading.value = true;
    try {
      final user = await registerWithEmail(
        name: name,
        email: email,
        password: password,
      );
      currentUser.value = user;
    } finally {
      isRegisterLoading.value = false;
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    currentUser.value = null;

    isHumanCheckedLogin.value = false;
    isHumanCheckedRegister.value = false;
    obscureLoginPassword.value = true;
    obscureRegisterPassword.value = true;
  }
}
