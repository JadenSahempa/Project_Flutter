import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/courseAddController.dart';

class TambahKelasScreen extends StatelessWidget {
  const TambahKelasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CourseAddController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kelas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: c.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Nama Kelas =====
              TextFormField(
                controller: c.namaC,
                decoration: const InputDecoration(
                  labelText: 'Nama Kelas',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama kelas tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // ===== Deskripsi =====
              TextFormField(
                controller: c.deskripsiC,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // ===== Harga (sementara selalu gratis) =====
              TextFormField(
                controller: c.hargaC,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              // ===== Thumbnail URL =====
              TextFormField(
                controller: c.thumbC,
                decoration: const InputDecoration(
                  labelText: 'Thumbnail URL (opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // ===== Tipe Kelas (SPL / Prakerja) =====
              const Text(
                'Tipe Kelas',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              Obx(
                () => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Kelas SPL'),
                  value: c.isSpl.value,
                  onChanged: (v) => c.isSpl.value = v ?? false,
                ),
              ),
              Obx(
                () => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Kelas Prakerja'),
                  value: c.isPrakerja.value,
                  onChanged: (v) => c.isPrakerja.value = v ?? false,
                ),
              ),
              const SizedBox(height: 16),

              // ===== Status Kelas =====
              const Text(
                'Status Kelas',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: c.status.value,
                  items: const [
                    DropdownMenuItem(value: 'draft', child: Text('Draft')),
                    DropdownMenuItem(
                      value: 'published',
                      child: Text('Published'),
                    ),
                    DropdownMenuItem(
                      value: 'maintenance',
                      child: Text('Maintenance'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) c.status.value = val;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ===== Tombol Aksi =====
              Row(
                children: [
                  // SIMPAN
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: c.isSubmitting.value
                            ? null
                            : () => c.submit(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 1.5,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: c.isSubmitting.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text('Simpan'),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // BATAL
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        foregroundColor: Colors.grey,
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
