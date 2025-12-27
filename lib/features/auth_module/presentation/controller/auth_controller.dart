import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
import 'package:luar_sekolah_lms/features/auth_module/presentation/widgets/app_snackbar.dart';
import 'package:luar_sekolah_lms/main_shell.dart';

String mapLoginError(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
      return 'Akun dengan email tersebut tidak ditemukan.';
    case 'wrong-password':
      return 'Password yang kamu masukkan salah.';
    case 'invalid-email':
      return 'Format email tidak valid.';
    case 'user-disabled':
      return 'Akun ini telah dinonaktifkan.';
    case 'invalid-credential':
      return 'Email atau password yang kamu masukkan salah atau kredensial sudah kadaluarsa.';
    default:
      return 'Gagal Login, Silahkan masukkan email dan password dengan benar.';
  }
}

String mapRegisterError(FirebaseAuthException e) {
  switch (e.code) {
    case 'email-already-in-use':
      return 'Email ini sudah terdaftar. Coba login atau gunakan email lain.';
    case 'invalid-email':
      return 'Format email tidak valid.';
    case 'weak-password':
      return 'Password terlalu lemah. Gunakan kombinasi huruf dan angka.';
    case 'operation-not-allowed':
      return 'Metode email/password belum diaktifkan di Firebase.';
    default:
      return 'Gagal registrasi: ${e.message ?? 'Terjadi kesalahan. Coba lagi.'}';
  }
}

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

  // Controllers untuk login form
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final user = getCurrentUser();
    currentUser.value = user;
    if (user != null) {
      _loadUserProfile(user.uid);
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }

  Future<void> submitLogin(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    final form = formKey.currentState!;
    final ok = form.validate();

    if (!ok) {
      showErrorSnackBar(context, '⚠️ Periksa kembali email dan password kamu');
      return;
    }

    if (!isHumanCheckedLogin.value) {
      showErrorSnackBar(context, 'Centang "I\'m not a robot" dulu ya');
      return;
    }

    try {
      await login(email: emailC.text.trim(), password: passC.text.trim());

      if (currentUser.value == null) {
        showErrorSnackBar(context, 'Login gagal. Silakan coba lagi.');
        return;
      }

      final profile = currentUserProfile.value;
      final fallbackEmail = currentUser.value?.email ?? 'User';

      final name = (profile?.name?.isNotEmpty ?? false)
          ? profile!.name
          : fallbackEmail;

      showSuccessSnackBar(context, 'Berhasil login. Selamat datang, $name 👋');
    } on FirebaseAuthException catch (e) {
      final msg = mapLoginError(e);
      showErrorSnackBar(context, msg);
    } catch (_) {
      showErrorSnackBar(
        context,
        'Terjadi kesalahan tak terduga. Coba lagi beberapa saat lagi.',
      );
    }
  }

  Future<void> submitRegister(
    BuildContext context,
    GlobalKey<FormState> formKey, {
    required TextEditingController nameC,
    required TextEditingController emailC,
    required TextEditingController numberC,
    required TextEditingController passC,
  }) async {
    final form = formKey.currentState!;
    final ok = form.validate();

    if (!ok) {
      showErrorSnackBar(context, '⚠️ Periksa kembali data registrasimu');
      return;
    }

    if (!isHumanCheckedRegister.value) {
      showErrorSnackBar(context, 'Centang "I\'m not a robot" dulu ya');
      return;
    }

    try {
      await register(
        name: nameC.text.trim(),
        email: emailC.text.trim(),
        password: passC.text.trim(),
      );

      final user = currentUser.value;

      // Nama yang kita pakai untuk greeting
      String greetingName = nameC.text.trim();
      if (greetingName.isEmpty) {
        if ((user?.displayName?.isNotEmpty ?? false)) {
          greetingName = user!.displayName!;
        } else {
          greetingName = user?.email ?? 'User';
        }
      }

      showSuccessSnackBar(
        context,
        'Registrasi berhasil 🎉\nSilakan login, $greetingName',
      );

      // Logout supaya tidak auto login
      await logout();

      // Arahkan ke login, bersihin stack
      Get.offAllNamed('/login');
    } on FirebaseAuthException catch (e) {
      final msg = mapRegisterError(e);
      showErrorSnackBar(context, msg);
    } catch (_) {
      showErrorSnackBar(
        context,
        'Terjadi kesalahan tak terduga saat registrasi. Coba lagi.',
      );
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

      if (profile.role == "admin") {
        Get.offAll(() => const AdminShell());
      } else {
        Get.offAll(() => const MainShell());
      }
      // ignore: unused_catch_stack
    } on FirebaseAuthException catch (e, st) {
      // print('🔥 ERROR di login(): $e');
      // print(st);
      rethrow; // lempar ke submitLogin
      // ignore: unused_catch_stack
    } catch (e, st) {
      // print('🔥 ERROR tak terduga di login(): $e');
      // print(st);
      rethrow;
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

      final profile = UserProfileEntity(
        uid: user.uid,
        email: user.email!,
        name: name,
        role: 'student',
      );

      await createUserProfileUseCase(profile);

      currentUserProfile.value = profile;
      // ignore: unused_catch_stack
    } catch (e, st) {
      // print('🔥 ERROR di register(): $e');
      // print(st);
      rethrow;
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

    emailC.clear();
    passC.clear();
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
        Get.offAll(() => const AdminShell());
      } else {
        Get.offAll(() => const MainShell());
      }
    } catch (e) {
      Get.offAllNamed('/login');
    }
  }

  // 🔹 Simpan profil ke Firestore
  Future<void> updateProfile({
    required BuildContext context,
    required String name,
    String? photoUrl,
    String? dob,
    String? gender,
    String? jobStatus,
    String? address,
  }) async {
    final authUser = currentUser.value;
    final oldProfile = currentUserProfile.value;

    if (authUser == null) {
      showErrorSnackBar(context, 'Kamu belum login.');
      return;
    }

    final user = UserProfileEntity(
      uid: authUser.uid,
      email: authUser.email ?? oldProfile?.email ?? '',
      role: oldProfile?.role ?? 'student',
      name: name,
      photoUrl: photoUrl,
      dob: dob,
      gender: gender,
      jobStatus: jobStatus,
      address: address,
    );

    try {
      await createUserProfileUseCase(user); // 🔥 upsert ke Firestore
      currentUserProfile.value = user;
      showSuccessSnackBar(context, 'Profil berhasil disimpan ✅');
    } catch (e) {
      showErrorSnackBar(context, 'Gagal menyimpan profil. Coba lagi nanti.');
    }
  }
}
