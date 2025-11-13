import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/create_course.dart';
import 'course_list_controller.dart';

class CourseAddController extends GetxController {
  final CreateCourse createCourse;
  final CourseListController? listController; // opsional untuk refresh
  CourseAddController({required this.createCourse, this.listController});

  final formKey = GlobalKey<FormState>();
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final ratingC = TextEditingController();
  final thumbC = TextEditingController();
  final kategori = RxnString();

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    final name = namaC.text.trim();
    final parsed = double.tryParse(hargaC.text.trim()) ?? 0;
    final priceStr = parsed.toStringAsFixed(2);
    final tags = [kategori.value!]; // ['prakerja'] atau ['spl']

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await createCourse(
        name: name,
        categoryTag: tags,
        price: priceStr,
        rating: ratingC.text.trim(),
        thumbnail: thumbC.text.trim(),
      );
      await listController?.reload();
      Get.back();
      Get.back(result: true);
    } catch (e) {
      Get.back();
      Get.snackbar('Gagal', e.toString());
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
