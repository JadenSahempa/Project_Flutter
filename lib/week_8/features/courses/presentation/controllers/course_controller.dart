import 'package:get/get.dart';
import '../../domain/entities/course.dart';
import '../../domain/use_cases/get_courses_use_case.dart';
import '../../domain/use_cases/create_course_use_case.dart';
import '../../domain/use_cases/update_course_use_case.dart';
import '../../domain/use_cases/delete_course_use_case.dart';

class CourseController extends GetxController {
  final GetCoursesUseCase getUC;
  final CreateCourseUseCase createUC;
  final UpdateCourseUseCase updateUC;
  final DeleteCourseUseCase deleteUC;

  CourseController({
    required this.getUC,
    required this.createUC,
    required this.updateUC,
    required this.deleteUC,
  });

  final courses = <Course>[].obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    try {
      courses.value = await getUC();
    } finally {
      loading.value = false;
    }
  }

  Future<void> create({
    required String title,
    required int price,
    required String category,
  }) async {
    final c = await createUC(title: title, price: price, category: category);
    courses.add(c);
  }

  Future<void> updateCourse({
    required String id,
    required String title,
    required int price,
    required String category,
  }) async {
    final c = await updateUC(
      id: id,
      title: title,
      price: price,
      category: category,
    );
    final idx = courses.indexWhere((e) => e.id == id);
    if (idx >= 0) courses[idx] = c;
  }

  Future<void> remove(String id) async {
    await deleteUC(id);
    courses.removeWhere((e) => e.id == id);
  }
}
