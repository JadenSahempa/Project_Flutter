import 'package:flutter/material.dart';
import 'package:luar_sekolah_lms/week_4/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  bool _obscure = true;
  bool _isChecked = false;
  String? _captchaError;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final form = _formKey.currentState!;
    final fieldsOk = form.validate();

    if (!fieldsOk) {
      // email/password invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Periksa kembali input kamu')),
      );
      return;
    }

    // cek captcha
    if (!_isChecked) {
      setState(() {
        _captchaError = 'Harap centang "I\'m not a robot"';
      });
      // beri feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Centang "I\'m not a robot" dulu ya')),
      );
      return;
    }

    // if semua valid
    setState(() => _captchaError = null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Login valid, lanjut ke halaman berikut!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode
                .disabled, // error hanya muncul saat tombol ditekan
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'lib/assets/images/luarsekolah.png',
                      height: 50,
                    ),
                  ),

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
                    controller: _emailC,
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

                  const Text('Password'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passC,
                    obscureText: _obscure,
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
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: Validators.validatePassword,
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Text('Lupa password'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // recapta checklist
                  Container(
                    width: double.infinity,
                    height: 80,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _captchaError == null
                            ? Colors.grey.shade300
                            : Colors.red.shade300, // merah saat error
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (v) {
                            setState(() {
                              _isChecked = v ?? false;
                              _captchaError =
                                  null; // hapus error saat user mencentang/ubah
                            });
                          },
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
                  if (_captchaError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _captchaError!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Masuk'),
                    ),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {},
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
      ),
    );
  }
}
