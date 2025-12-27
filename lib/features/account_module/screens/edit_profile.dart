import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:luar_sekolah_lms/features/account_module/utils/validators.dart';
import 'package:luar_sekolah_lms/features/auth_module/presentation/controller/auth_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameC = TextEditingController(text: 'Ahmad Sahroni');
  final _dobC = TextEditingController();
  final _addressC = TextEditingController();

  /// ✅ URL foto profil (nanti bisa diisi dari data user Firestore)
  final _photoUrlC = TextEditingController(
    text:
        'https://images.unsplash.com/photo-1525134479668-1bee5c7c6845?w=400', // dummy awal
  );

  String? _gender;
  String? _jobStatus;
  String _role = 'student'; // default kalau belum ada

  late final AuthController _authC;

  @override
  void initState() {
    super.initState();
    _authC = Get.find<AuthController>();

    // 🔹 Prefill dari profile user jika sudah ada di AuthController
    final profile = _authC.currentUserProfile.value;
    if (profile != null) {
      _nameC.text = profile.name ?? _nameC.text;
      _photoUrlC.text = profile.photoUrl ?? _photoUrlC.text;
      _dobC.text = profile.dob ?? '';
      _gender = profile.gender;
      _jobStatus = profile.jobStatus;
      _addressC.text = profile.address ?? '';
      _role = profile.role
      // ?? 'student'
      ;
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _dobC.dispose();
    _addressC.dispose();
    _photoUrlC.dispose();
    super.dispose();
  }

  bool get _ready =>
      _nameC.text.trim().length >= 3 &&
      _dobC.text.isNotEmpty &&
      _gender != null &&
      _jobStatus != null &&
      _addressC.text.trim().length >= 10;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await _authC.updateProfile(
      context: context,
      name: _nameC.text.trim(),
      photoUrl: _photoUrlC.text.trim().isEmpty ? null : _photoUrlC.text.trim(),
      dob: _dobC.text.trim().isEmpty ? null : _dobC.text.trim(),
      gender: _gender,
      jobStatus: _jobStatus,
      address: _addressC.text.trim().isEmpty ? null : _addressC.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Profil berhasil disimpan!')),
    );

    // Optional: tutup layar
    // Navigator.of(context).pop();
  }

  /// 🔹 Helper: bangun avatar dari URL atau tampilkan placeholder
  Widget _buildAvatar({double radius = 50}) {
    final url = _photoUrlC.text.trim();

    if (url.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.teal.shade50,
        child: Icon(Icons.person, size: radius, color: Colors.teal.shade700),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      foregroundImage: NetworkImage(url),
      child: Icon(Icons.person, size: radius, color: Colors.grey[400]),
    );
  }

  String get _greetingText {
    if (_role == 'admin') {
      return 'Kelola profilmu sebagai Admin,';
    }
    return 'Semangat Belajarnya,';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // =============== Header ===============
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Avatar kecil di header pakai URL juga
                        _buildAvatar(radius: 24),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greetingText,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _nameC.text,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Avatar besar + tombol hapus
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _buildAvatar(radius: 50),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: IconButton(
                            onPressed: () {
                              _photoUrlC.clear();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 16,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.all(6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tempel URL foto profil kamu (JPG/PNG).\n'
                      'Contoh: link dari Firebase Storage atau hosting gambar.',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Input URL Foto Profil
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(
                        width: 350,
                        height: 48,
                      ),
                      child: TextFormField(
                        controller: _photoUrlC,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.link),
                          hintText: 'URL foto profil (opsional)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        validator: (v) {
                          final text = v?.trim() ?? '';
                          if (text.isEmpty) return null; // opsional
                          final uri = Uri.tryParse(text);
                          if (uri == null || !uri.isAbsolute) {
                            return 'URL tidak valid';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =============== FORM VALIDASI ===============
              Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Data Diri',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Nama Lengkap
                        const Text('Nama Lengkap'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameC,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Nama lengkapmu',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          validator: (v) =>
                              Validators.requiredText(v, field: 'Nama') ??
                              Validators.minLen(v, 3, field: 'Nama'),
                        ),

                        const SizedBox(height: 14),

                        // Tanggal Lahir
                        const Text('Tanggal Lahir'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _dobC,
                          readOnly: true,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_month_outlined),
                            hintText: 'Masukkan tanggal lahirmu',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          onTap: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateUtilsExt.suggestInitial18yo(),
                              firstDate: DateTime(1900),
                              lastDate: now,
                            );
                            if (picked != null) {
                              _dobC.text = DateUtilsExt.toDdMMyyyy(picked);
                              setState(() {});
                            }
                          },
                          validator: Validators.dateDdMMyyyy,
                        ),

                        const SizedBox(height: 14),

                        // Jenis Kelamin
                        const Text('Jenis Kelamin'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          onChanged: (v) => setState(() => _gender = v),
                          items: const [
                            DropdownMenuItem(
                              value: 'L',
                              child: Text('Laki-laki'),
                            ),
                            DropdownMenuItem(
                              value: 'P',
                              child: Text('Perempuan'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Pilih jenis kelamin',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          validator: (v) => Validators.requiredDropdown(
                            v,
                            field: 'jenis kelamin',
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Status Pekerjaan
                        const Text('Status Pekerjaan'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _jobStatus,
                          onChanged: (v) => setState(() => _jobStatus = v),
                          items: const [
                            DropdownMenuItem(
                              value: 'pelajar',
                              child: Text('Pelajar/Mahasiswa'),
                            ),
                            DropdownMenuItem(
                              value: 'karyawan',
                              child: Text('Karyawan'),
                            ),
                            DropdownMenuItem(
                              value: 'freelance',
                              child: Text('Freelance'),
                            ),
                            DropdownMenuItem(
                              value: 'wirausaha',
                              child: Text('Wirausaha'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Pilih status pekerjaanmu',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          validator: (v) => Validators.jobSelected(
                            v,
                            field: 'status pekerjaan',
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Alamat Lengkap
                        const Text('Alamat Lengkap'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _addressC,
                          maxLines: 3,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Masukkan alamat lengkap',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.all(12),
                          ),
                          validator: (v) =>
                              Validators.requiredText(v, field: 'Alamat') ??
                              Validators.minLen(v, 10, field: 'Alamat'),
                        ),

                        const SizedBox(height: 20),

                        // Tombol Simpan
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: _ready ? _submit : null,
                            child: const Text('Simpan Perubahan'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
