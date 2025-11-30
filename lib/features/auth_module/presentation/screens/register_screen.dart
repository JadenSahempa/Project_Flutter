// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luar_sekolah_lms/router/app_router.dart';
import 'package:luar_sekolah_lms/week_4/utils/validators.dart';
import 'package:luar_sekolah_lms/week_9/presentation/controller/auth_controller.dart';
import 'package:luar_sekolah_lms/week_9/presentation/screens/login_screen.dart';
import 'package:luar_sekolah_lms/week_9/presentation/widgets/app_snackbar.dart';

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

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers input
    final nameC = TextEditingController();
    final emailC = TextEditingController();
    final numberC = TextEditingController();
    final passC = TextEditingController();

    final formKey = GlobalKey<FormState>();

    Future<void> onSubmit() async {
      final form = formKey.currentState!;
      final ok = form.validate();

      if (!ok) {
        showErrorSnackBar(context, '⚠️ Periksa kembali data registrasimu');
        return;
      }

      if (!controller.isHumanCheckedRegister.value) {
        showErrorSnackBar(context, 'Centang "I\'m not a robot" dulu ya');
        return;
      }

      controller.isRegisterLoading.value = true;
      try {
        // 1️⃣ Daftarkan user ke Firebase
        await controller.register(
          name: nameC.text.trim(),
          email: emailC.text.trim(),
          password: passC.text.trim(),
        );

        final user = controller.currentUser.value;

        if (user != null) {
          final name = (user.displayName?.isNotEmpty ?? false)
              ? user.displayName!
              : (user.email ?? 'User');

          // Tampilkan snackbar sukses
          showSuccessSnackBar(
            context,
            'Registrasi berhasil 🎉\nSilakan login, $name',
          );

          // Logout dulu supaya tidak auto login ke dashboard
          await controller.logout();

          // Arahkan ke halaman login, bersihkan stack
          if (!context.mounted) return;
          AppRouter.goToLoginClearingStack(context);
        }
      } on FirebaseAuthException catch (e) {
        final msg = mapRegisterError(e); // fungsi mapper yang kemarin
        showErrorSnackBar(context, msg);
      } catch (_) {
        showErrorSnackBar(
          context,
          'Terjadi kesalahan tak terduga saat registrasi. Coba lagi.',
        );
      } finally {
        controller.isRegisterLoading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),

            // ========= FORM =========
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'lib/assets/images/luarsekolah.png',
                      height: 50,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Daftarkan Akun Untuk Lanjut Akses ke Luarsekolah",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Satu akun untuk akses Luarsekolah dan BelajarBekerja",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Google button (belum dihubungkan)
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      'lib/assets/images/google.png',
                      height: 20,
                    ),
                    label: const Text(
                      "Masuk dengan Google",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("atau gunakan email"),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ===== Nama Lengkap =====
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Nama Lengkap'),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: nameC,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Ahmad Sahroni',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    validator: (v) =>
                        Validators.requiredText(v, field: 'Nama') ??
                        Validators.minLen(v, 3, field: 'Nama'),
                  ),

                  const SizedBox(height: 16),

                  // ===== Email =====
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Email Aktif'),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: emailC,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'user@example.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    validator: Validators.validateEmail,
                  ),

                  const SizedBox(height: 16),

                  // ===== Nomor WhatsApp =====
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Nomor Whatsapp Aktif'),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: numberC,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '62812xxxxxx',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    validator: Validators.validatePhone,
                  ),

                  const SizedBox(height: 16),

                  // ===== Password =====
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Password'),
                  ),
                  const SizedBox(height: 6),

                  Obx(
                    () => TextFormField(
                      controller: passC,
                      obscureText: controller.obscureRegisterPassword.value,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              controller.obscureRegisterPassword.toggle(),
                          icon: Icon(
                            controller.obscureRegisterPassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: Validators.validatePassword,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== RECAPTCHA CHECKBOX =====
                  Obx(
                    () => Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: controller.isHumanCheckedRegister.value
                              ? Colors.grey.shade300
                              : Colors.red.shade300,
                        ),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: controller.isHumanCheckedRegister.value,
                            onChanged: (bool? v) =>
                                controller.isHumanCheckedRegister.value =
                                    v ?? false,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "I'm not a robot",
                            style: TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(height: 4),
                              Text('reCAPTCHA', style: TextStyle(fontSize: 11)),
                              Text(
                                'Privacy • Terms',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ===== BUTTON DAFTARKAN AKUN =====
                  Obx(
                    () => SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isRegisterLoading.value
                            ? null
                            : onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D5A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isRegisterLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Daftarkan Akun',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== Terms =====
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Dengan mendaftar di Luarsekolah, kamu menyetujui ',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'syarat dan ketentuan kami',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ===== CTA ke Login =====
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF90CAF9)),
                    ),
                    child: Row(
                      children: [
                        const Text('👋'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Sudah punya akun? ',
                                style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Masuk ke akunmu',
                                  style: TextStyle(
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
