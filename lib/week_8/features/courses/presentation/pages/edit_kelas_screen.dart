import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'new_kelas_result.dart';
import '../controllers/course_edit_controller.dart';
import 'package:get/get.dart';

class EditKelasScreen extends StatefulWidget {
  final String courseId;
  const EditKelasScreen({super.key, required this.courseId});

  @override
  State<EditKelasScreen> createState() => _EditKelasScreenState();
}

class _EditKelasScreenState extends State<EditKelasScreen> {
  @override
  Widget build(BuildContext context) {
    final c = Get.put(
      CourseEditController(
        courseId: widget.courseId,
        getByIdUC: Get.find(),
        updateUC: Get.find(),
      ),
      tag: widget.courseId,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Informasi Kelas')),
      body: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.error.value != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Terjadi masalah:\n${c.error.value}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => c
                    ..error.value = null
                    ..fetch(),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
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
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            hintText: 'e.g 1000000',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Harga wajib diisi';
                            }
                            if (int.tryParse(v) == null) {
                              return 'Harus angka bulat';
                            }
                            if ((int.tryParse(v) ?? 0) < 0) {
                              return 'Tidak boleh negatif';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        const Text('Kategori (tag)'),
                        const SizedBox(height: 6),
                        Obx(
                          () => Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _TagChip(
                                label: 'Prakerja',
                                selected: c.kategori.contains('prakerja'),
                                onTap: () {
                                  const k = 'prakerja';
                                  c.kategori.contains(k)
                                      ? c.kategori.remove(k)
                                      : c.kategori.assignAll([k]);
                                },
                              ),
                              _TagChip(
                                label: 'SPL',
                                selected: c.kategori.contains('spl'),
                                onTap: () {
                                  const k = 'spl';
                                  c.kategori.contains(k)
                                      ? c.kategori.remove(k)
                                      : c.kategori.assignAll([k]);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          height: 44,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: c.loading.value ? null : c.submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0FA958),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: c.loading.value
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Simpan Perubahan'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

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
        );
      }),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TagChip({
    required this.label,
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
