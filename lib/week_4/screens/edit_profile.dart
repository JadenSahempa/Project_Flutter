import 'package:flutter/material.dart';
import 'package:luar_sekolah_lms/week_4/utils/validators.dart';

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
  String? _gender;
  String? _jobStatus;

  @override
  void dispose() {
    _nameC.dispose();
    _dobC.dispose();
    _addressC.dispose();
    super.dispose();
  }

  bool get _ready =>
      _nameC.text.trim().length >= 3 &&
      _dobC.text.isNotEmpty &&
      _gender != null &&
      _jobStatus != null &&
      _addressC.text.trim().length >= 10;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Data valid & siap disimpan!')),
      );
    }
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
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage(
                            'lib/assets/images/person3.jpg',
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Semangat Belajarnya,',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Ahmad Sahroni',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Tombol navigasi
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(
                        width: 350,
                        height: 45,
                      ),
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.grid_view_rounded, size: 18),
                        label: const Text(
                          'Buka Navigasi Menu',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Avatar edit foto
                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                            'lib/assets/images/person3.jpg',
                          ),
                        ),
                        Positioned(
                          top: -4,
                          right: -4,
                          child: IconButton(
                            onPressed: () {
                              debugPrint('Foto dihapus!');
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
                      'Upload foto baru dengan ukuran < 1 MB,\ndan bertipe JPG atau PNG.',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(
                        width: 350,
                        height: 45,
                      ),
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.image_outlined, size: 18),
                        label: const Text(
                          'Upload Foto',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
                          initialValue: _gender,
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
                          initialValue: _jobStatus,
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
                          validator: (v) =>
                              Validators.jobSelected(v, field: 'jenis kelamin'),
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
