import 'package:get/get.dart';

import '../../../domain/entities/course_entity.dart';
import '../../../domain/usecases/get_courses.dart';
import '../../../domain/usecases/delete_course.dart';

class CourseController extends GetxController {
  final GetCoursesUseCase getCoursesUseCase;
  final DeleteCourseUseCase deleteCourseUseCase;

  CourseController({
    required this.getCoursesUseCase,
    required this.deleteCourseUseCase,
  });

  final isLoading = false.obs;
  final error = RxnString();
  final courses = <CourseEntity>[].obs;

  /// Semua course yang di-load dari Firestore
  List<CourseEntity> get allCourses => courses;

  /// Kelas Terpopuler:
  /// - (opsi) hanya published kalau mau, atau semua;
  /// - sort by enrollmentCount desc, lalu rating desc.
  List<CourseEntity> get popularCourses {
    // 1) Filter: hanya published & punya rating valid
    final filtered = courses.where((c) {
      final r = c.rating?.trim();
      if (c.status != 'published') return false;
      if (r == null || r.isEmpty) return false;
      return double.tryParse(r) != null;
    }).toList();

    // 2) Sort: rating desc, kalau sama pakai enrollmentCount desc
    filtered.sort((a, b) {
      final ra = double.tryParse(a.rating ?? '0') ?? 0;
      final rb = double.tryParse(b.rating ?? '0') ?? 0;

      final cmpRating = rb.compareTo(ra); // besar → kecil
      if (cmpRating != 0) return cmpRating;

      return b.enrollmentCount.compareTo(a.enrollmentCount);
    });

    return filtered;
  }

  /// Kelas SPL = yang punya tag 'SPL'
  List<CourseEntity> get splCourses {
    return courses.where((c) {
      final tags = c.categoryTag.map((e) => e.toUpperCase()).toList();
      return tags.contains('SPL');
    }).toList();
  }

  /// Kelas Lainnya = yang bukan SPL & bukan Prakerja
  List<CourseEntity> get prakerjaCourses {
    return courses.where((c) {
      final tags = c.categoryTag.map((e) => e.toUpperCase()).toList();
      return tags.contains('PRAKERJA');
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadCourses();
  }

  Future<void> loadCourses() async {
    isLoading.value = true;
    error.value = null;

    try {
      final result = await getCoursesUseCase();
      courses.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reload() => loadCourses();

  Future<void> deleteCourse(String id) async {
    try {
      await deleteCourseUseCase(id);
      await loadCourses();
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus course: $e');
    }
  }
}
