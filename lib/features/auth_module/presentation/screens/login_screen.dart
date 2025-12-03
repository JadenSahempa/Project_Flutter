// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luar_sekolah_lms/router/app_router.dart';
import 'package:luar_sekolah_lms/features/account_module/utils/validators.dart';
import 'package:luar_sekolah_lms/main_example.dart';
import 'package:luar_sekolah_lms/features/auth_module/presentation/controller/auth_controller.dart';
import 'package:luar_sekolah_lms/features/auth_module/presentation/screens/register_screen.dart';
import 'package:luar_sekolah_lms/features/auth_module/presentation/widgets/app_snackbar.dart';

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
    default:
      return 'Gagal Login, Silahkan Masukan Email dan Password dengan Benar';
  }
}

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailC = TextEditingController();
    final passC = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Future<void> onSubmit() async {
      final form = formKey.currentState!;
      final ok = form.validate();

      if (!ok) {
        showErrorSnackBar(
          context,
          '⚠️ Periksa kembali email dan password kamu',
        );
        return;
      }

      if (!controller.isHumanCheckedLogin.value) {
        showErrorSnackBar(context, 'Centang "I\'m not a robot" dulu ya');
        return;
      }

      try {
        await controller.login(
          email: emailC.text.trim(),
          password: passC.text.trim(),
        );

        final user = controller.currentUser.value;
        if (user != null) {
          final name = (user.displayName?.isNotEmpty ?? false)
              ? user.displayName!
              : (user.email ?? 'User');

          showSuccessSnackBar(
            context,
            'Berhasil login. Selamat datang, $name 👋',
          );
        }
      } on FirebaseAuthException catch (e) {
        // 🔥 error salah email/pass, dsb
        final msg = mapLoginError(e);
        showErrorSnackBar(context, msg);
      } catch (_) {
        showErrorSnackBar(
          context,
          'Terjadi kesalahan tak terduga. Coba lagi beberapa saat lagi.',
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Pages'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainExample()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('lib/assets/images/luarsekolah.png', height: 50),
                const SizedBox(height: 16),
                const Text(
                  "Masuk ke Akunmu Untuk Lanjut Akses ke Luarsekolah",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Satu akun untuk akses Luarsekolah dan BelajarBekerja",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.asset('lib/assets/images/google.png', height: 20),
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
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("atau gunakan email"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                const Text('Email'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: emailC,
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'user@example.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text('Password'),
                const SizedBox(height: 6),

                Obx(
                  () => TextFormField(
                    controller: passC,
                    obscureText: controller.obscureLoginPassword.value,
                    validator: Validators.validatePassword,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () =>
                            controller.obscureLoginPassword.toggle(),
                        icon: Icon(
                          controller.obscureLoginPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Lupa password'),
                  ),
                ),

                const SizedBox(height: 16),

                Obx(
                  () => Container(
                    width: double.infinity,
                    height: 80,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: controller.isHumanCheckedLogin.value
                            ? Colors.grey.shade300
                            : Colors.red.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: controller.isHumanCheckedLogin.value,
                          onChanged: (v) =>
                              controller.isHumanCheckedLogin.value = v ?? false,
                        ),
                        const SizedBox(width: 8),
                        const Text("I'm not a robot"),
                        const Spacer(),
                        Container(
                          width: 90,
                          height: 40,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: const Text('reCAPTCHA'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoginLoading.value
                          ? null
                          : onSubmit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: controller.isLoginLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Masuk'),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("👋  Belum punya akun? "),
                        Text(
                          "Daftar Sekarang",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
