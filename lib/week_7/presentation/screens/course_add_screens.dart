import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luar_sekolah_lms/week_7/presentation/controllers/course_add_controller.dart';

class TambahKelasScreen extends StatelessWidget {
  const TambahKelasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CourseAddController());

    return Scaffold(
      appBar: AppBar(title: const Text('Informasi Kelas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: c.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Informasi Kelas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text('Nama Kelas'),

                      const SizedBox(height: 6),
                      TextFormField(
                        controller: c.namaC,
                        decoration: const InputDecoration(
                          hintText: 'e.g Marketing Communication',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama wajib diisi'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      const Text('Harga Kelas'),

                      const SizedBox(height: 6),

                      TextFormField(
                        controller: c.hargaC,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          hintText: 'e.g 1000000',
                          helperText: 'Masukkan dalam bentuk angka',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Harga wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      const Text('Kategori Kelas'),

                      const SizedBox(height: 6),

                      Obx(
                        () => DropdownButtonFormField<String>(
                          initialValue: c.kategori.value,
                          items: const [
                            DropdownMenuItem(
                              value: 'Prakerja',
                              child: Text('Prakerja'),
                            ),
                            DropdownMenuItem(value: 'SPL', child: Text('SPL')),
                          ],
                          onChanged: (v) => c.kategori.value = v,
                          decoration: const InputDecoration(
                            hintText: 'Pilih Prakerja atau SPL',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v == null ? 'Kategori wajib dipilih' : null,
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: c.submit, // <-- kirim ke API + update list
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF116E55),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Simpan Perubahan'),
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1EC38B),
                            side: const BorderSide(color: Color(0xFF1EC38B)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Kembali'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
