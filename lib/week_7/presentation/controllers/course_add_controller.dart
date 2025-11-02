import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luar_sekolah_lms/week_7/services/course_api_service.dart';
import 'package:luar_sekolah_lms/week_7/presentation/controllers/course_controller.dart';

class NewKelasResult {
  final String nama;
  final int harga;
  final String kategori;
  NewKelasResult({
    required this.nama,
    required this.harga,
    required this.kategori,
  });
}

class CourseAddController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final kategori = RxnString();

  late final CourseApiService api;
  CourseController? listCtrl;

  @override
  void onInit() {
    super.onInit();
    api = Get.find<CourseApiService>(); // sudah di-register di main.dart
    if (Get.isRegistered<CourseController>(tag: 'popular')) {
      listCtrl = Get.find<CourseController>(tag: 'popular');
    }
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final name = namaC.text.trim();
    final hargaInt = int.tryParse(hargaC.text.trim());
    if (hargaInt == null) {
      Get.snackbar('Validasi', 'Harga tidak valid');
      return;
    }
    final cat = kategori.value;
    if (cat == null) {
      Get.snackbar('Validasi', 'Pilih kategori');
      return;
    }

    final priceStr = (hargaInt + .0).toStringAsFixed(2);
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await api.create(
        name: name,
        categoryTag: [cat.toLowerCase()],
        price: priceStr,
      );

      // opsional: segarkan list popular di sini (aman untuk paging)
      await listCtrl?.reload();

      Get.back(); // tutup loading
      Get.back(result: true); // balik ke tab + beri sinyal sukses
    } catch (e) {
      Get.back(); // tutup loading
      Get.snackbar('Gagal', e.toString());
    }
  }

  @override
  void onClose() {
    namaC.dispose();
    hargaC.dispose();
    super.onClose();
  }
}
