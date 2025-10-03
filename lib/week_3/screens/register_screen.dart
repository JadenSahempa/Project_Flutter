import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _numberC = TextEditingController();
  final _passC = TextEditingController();

  // Variabel untuk show/hide password
  bool _obscure = true;

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _numberC.dispose();
    _passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Satu akun untuk akses Luarsekolah dan BelajarBekerja",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
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
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // <-- sudut melengkung 12 px
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

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Nama Lengkap'),
                ),
                const SizedBox(height: 6),
                TextField(
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
                ),

                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email Aktif'),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _numberC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'mail@mail.xo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Nomor Whatsapp Aktif'),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailC,
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
                ),
                const SizedBox(height: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 3, 100, 7),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text("Format Nomor diawali 62"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 3, 100, 7),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text("Minimal 10 angka"),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password'),
                ),
                const SizedBox(height: 6),

                TextField(
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
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 3, 100, 7),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text("Minimal 8 karakter"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 3, 100, 7),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text("Terdapat 1 huruf kapital"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 3, 100, 7),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text("Terdapat 1 angka"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 3, 100, 7),
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text("Terdapat 1 karakter simbol (!, @, dll)"),
                      ],
                    ),
                    const SizedBox(height: 16),

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
                            value: true,
                            onChanged: (bool? newValue) {
                              //logic interaktif
                            },
                          ),
                          const SizedBox(width: 12),

                          const Text(
                            "I'm not a robot",
                            style: TextStyle(fontSize: 16),
                          ),

                          const Spacer(),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 4),
                              const Text(
                                'reCAPTCHA',
                                style: TextStyle(fontSize: 11),
                              ),
                              const Text(
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {},
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
                                          // decoration: TextDecoration.underline,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
