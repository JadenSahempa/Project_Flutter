import 'package:get/get.dart';
import 'package:luar_sekolah_lms/admin_shell.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/entities/auth_user.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/entities/user_profile_entity.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/create_user_profile.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/get_current_user.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/login_with_email.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/logout.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/register_with_email.dart';
import 'package:luar_sekolah_lms/features/auth_module/domain/usecases/get_user_profile.dart';
import 'package:luar_sekolah_lms/main_shell.dart';

class AuthController extends GetxController {
  final LoginWithEmail loginWithEmail;
  final RegisterWithEmail registerWithEmail;
  final Logout logoutUseCase;
  final GetCurrentUser getCurrentUser;

  final CreateUserProfileUseCase createUserProfileUseCase;
  final GetUserProfileUseCase getUserProfileUseCase;

  Rx<UserProfileEntity?> currentUserProfile = Rx<UserProfileEntity?>(null);

  AuthController({
    required this.loginWithEmail,
    required this.registerWithEmail,
    required this.logoutUseCase,
    required this.getCurrentUser,
    required this.createUserProfileUseCase,
    required this.getUserProfileUseCase,
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
    final user = getCurrentUser();
    currentUser.value = user;
    if (user != null) {
      _loadUserProfile(user.uid);
    }
  }

  Future<void> _loadUserProfile(String uid) async {
    try {
      final profile = await getUserProfileUseCase(uid);
      currentUserProfile.value = profile;
    } catch (_) {
      // untuk sekarang, kalau gagal ambil profile kita biarkan saja
    }
  }

  Future<void> login({required String email, required String password}) async {
    isLoginLoading.value = true;
    try {
      final user = await loginWithEmail(email: email, password: password);
      currentUser.value = user;

      final profile = await getUserProfileUseCase(user.uid);

      currentUserProfile.value = profile;

      print('Ini adalah profile login: ${profile.role}');

      if (profile.role == "admin") {
        // TODO: nanti kalau sudah ada AdminShell, ganti ke situ
        Get.offAll(() => const AdminShell());
      } else {
        Get.offAll(() => const MainShell());
      }
    } catch (e, st) {
      print('🔥 ERROR di login(): $e');
      print(st);
      // di sini bisa show snackbar juga
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
      print('👉 MULAI REGISTER: $email');
      final user = await registerWithEmail(
        name: name,
        email: email,
        password: password,
      );

      print(
        '✅ FirebaseAuth register sukses. uid = ${user.uid}, email = ${user.email}',
      );

      currentUser.value = user;

      final profile = UserProfileEntity(
        uid: user.uid,
        email: user.email!,
        name: name, // ⬅️ ganti ke ini
        role: 'student',
      );

      print('👉 Mau simpan profile ke Firestore untuk uid: ${profile.uid}');
      await createUserProfileUseCase(profile);
      print('✅ Berhasil simpan profile ke Firestore');

      currentUserProfile.value = profile;

      // student → masuk ke MainShell
      // Get.offAll(() => const MainShell());
    } catch (e, st) {
      print('🔥 ERROR di register(): $e');
      print(st);
      rethrow; // biar RegisterScreen bisa nangkep di onSubmit kalau mau
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

  Future<void> checkAuthAndRoute() async {
    final authUser = await getCurrentUser();

    if (authUser == null) {
      Get.offAllNamed('/login');
      return;
    }

    try {
      final profile = await getUserProfileUseCase(authUser.uid);
      currentUser.value = authUser;
      currentUserProfile.value = profile;

      if (profile.role == 'admin') {
        // TODO: nanti kalau ada AdminShell
        // Get.offAll(() => const AdminShell());
      } else {
        Get.offAll(() => const MainShell());
      }
    } catch (e) {
      Get.offAllNamed('/login');
    }
  }
}
