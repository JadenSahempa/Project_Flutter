import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/courseAddController.dart';

class TambahKelasScreen extends StatelessWidget {
  const TambahKelasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CourseAddController());

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kelas')),
      // ⛔ tidak pakai Obx di level body
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
                        'Informasi Kelas Baru',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ===== Nama Kelas =====
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

                      // ===== Harga Kelas =====
                      const Text('Harga Kelas'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: c.hargaC,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        decoration: const InputDecoration(
                          hintText: 'e.g 1000000 atau 1000000.00',
                          helperText:
                              'Akan disimpan sebagai 2 desimal (####.##)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Harga wajib diisi'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      // ===== Kategori Multi Select =====
                      const Text('Kategori (bisa pilih lebih dari 1)'),
                      const SizedBox(height: 6),

                      Obx(
                        () => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _TagChipMulti(
                              label: 'Prakerja',
                              value: 'prakerja',
                              selected: c.kategori.contains('prakerja'),
                              onTap: () {
                                c.kategori.contains('prakerja')
                                    ? c.kategori.remove('prakerja')
                                    : c.kategori.add('prakerja');
                              },
                            ),
                            _TagChipMulti(
                              label: 'SPL',
                              value: 'spl',
                              selected: c.kategori.contains('spl'),
                              onTap: () {
                                c.kategori.contains('spl')
                                    ? c.kategori.remove('spl')
                                    : c.kategori.add('spl');
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ===== Rating (opsional) =====
                      const Text('Rating (opsional, contoh 4.5)'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: c.ratingC,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        decoration: const InputDecoration(
                          hintText: '4 atau 4.5',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ===== Thumbnail (opsional) =====
                      const Text('Thumbnail URL (opsional)'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: c.thumbC,
                        decoration: const InputDecoration(
                          hintText: 'https://...',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ===== Tombol Simpan =====
                      SizedBox(
                        height: 44,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: c.isSubmitting.value ? null : c.submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0FA958),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: c.isSubmitting.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Simpan'),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ===== Tombol Kembali =====
                      SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0FA958),
                            side: const BorderSide(color: Color(0xFF0FA958)),
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

class _TagChipMulti extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _TagChipMulti({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final on = selected;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: on ? const Color(0xFFE7F0FF) : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: on ? const Color(0xFF1E66F5) : const Color(0xFF495057),
          ),
        ),
      ),
    );
  }
}
