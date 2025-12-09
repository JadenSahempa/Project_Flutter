import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luar_sekolah_lms/features/account_module/utils/validators.dart';
import 'package:luar_sekolah_lms/features/auth_module/presentation/controller/auth_controller.dart';
import 'package:luar_sekolah_lms/features/auth_module/presentation/screens/login_screen.dart';

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
                            : () => controller.submitRegister(
                                context,
                                formKey,
                                nameC: nameC,
                                emailC: emailC,
                                numberC: numberC,
                                passC: passC,
                              ),
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
