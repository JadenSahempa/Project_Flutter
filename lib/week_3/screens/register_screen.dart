import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _numberC = TextEditingController();
  final _passC = TextEditingController();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // UI states
  bool _obscure = true;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _numberC.dispose();
    _passC.dispose();
    super.dispose();
  }

  // ========= Helpers (validator logic) =========
  bool _isValidEmail(String v) {
    final re = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    return re.hasMatch(v.trim());
  }

  bool _isValidPhone(String v) {
    final s = v.trim();
    // contoh rule: harus mulai '62', hanya digit, panjang 10..15
    if (!s.startsWith('62')) return false;
    if (!RegExp(r'^\d+$').hasMatch(s)) return false;
    if (s.length < 10 || s.length > 15) return false;
    return true;
  }

  void _onSubmit() {
    final form = _formKey.currentState!;
    // Validasi penuh dijalankan saat tombol ditekan
    final ok = form.validate();

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Periksa kembali input kamu')),
      );
      return;
    }

    //  “I’m not a robot”
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Centang "I\'m not a robot" dulu ya')),
      );
      return;
    }

    // return Semua valid
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Registrasi valid, proses pendaftaran...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),

            // ========== FORM WRAPPER ==========
            child: Form(
              key: _formKey,
              //autovalidate disabled
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
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

                  Row(
                    children: const [
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
                    controller: _nameC,
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
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      if (v.trim().length < 3) {
                        return 'Minimal 3 karakter';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ===== Email =====
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Email Aktif'),
                  ),
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
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!_isValidEmail(v)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ===== Nomor WhatsApp =====
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Nomor Whatsapp Aktif'),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _numberC,
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
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Nomor WA wajib diisi';
                      }
                      if (!_isValidPhone(v)) {
                        return 'Nomor harus mulai 62, angka saja, 10–15 digit';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ===== Password =====
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Password'),
                  ),
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
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Password wajib diisi';
                      }
                      if (v.trim().length < 6) {
                        return 'Minimal 6 karakter';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Recapta button
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (bool? v) =>
                              setState(() => _isChecked = v ?? false),
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

                  const SizedBox(height: 16),

                  //button daftar akun
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D5A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Daftarkan Akun',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ===== Terms & CTA Masuk =====
                  Wrap(
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
                  const SizedBox(height: 12),

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
                                onPressed: () {},
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
