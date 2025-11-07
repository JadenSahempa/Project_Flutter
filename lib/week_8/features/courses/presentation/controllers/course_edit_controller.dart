import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/course.dart';
import '../../domain/use_cases/get_course_by_id_use_case.dart';
import '../../domain/use_cases/update_course_use_case.dart';

class CourseEditController extends GetxController {
  final String courseId;
  final GetCourseByIdUseCase getByIdUC;
  final UpdateCourseUseCase updateUC;

  CourseEditController({
    required this.courseId,
    required this.getByIdUC,
    required this.updateUC,
  });

  final formKey = GlobalKey<FormState>();
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final ratingC =
      TextEditingController(); // opsional, tidak dipakai ke backend lama
  final thumbC = TextEditingController(); // opsional
  final kategori = <String>[].obs;

  final loading = false.obs;
  final error = RxnString();
  Course? current;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    loading.value = true;
    error.value = null;
    try {
      final c = await getByIdUC(courseId);
      current = c;
      namaC.text = c.name;
      hargaC.text = c.price.toString();
      // kategori (string) → tag pertama
      kategori
        ..clear()
        ..addAll(
          c.categoryTag.map((e) => e.toLowerCase()),
        ); // 'prakerja' / 'spl'
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    if (kategori.isEmpty) {
      Get.snackbar('Validasi', 'Minimal 1 kategori dipilih');
      return;
    }
    loading.value = true;
    try {
      final title = namaC.text.trim();
      final price = int.tryParse(hargaC.text.trim()) ?? 0;
      final category = kategori.first; // backend lama pakai string tunggal

      await updateUC(
        id: courseId,
        title: title,
        price: price,
        category: category,
      );

      Get.back(result: true); // beri sinyal sukses ke caller
      Get.snackbar('Sukses', 'Perubahan disimpan');
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    namaC.dispose();
    hargaC.dispose();
    ratingC.dispose();
    thumbC.dispose();
    super.onClose();
  }
}
