import 'package:get/get.dart';

import '../../../domain/entities/lesson_entity.dart';
import '../../../domain/usecases/get_lessons.dart';
import '../../../domain/usecases/create_lesson.dart';
import '../../../domain/usecases/update_lesson.dart';
import '../../../domain/usecases/delete_lesson.dart';

class CourseLessonsController extends GetxController {
  final String courseId;
  final GetLessonsUseCase getLessonsUseCase;
  final CreateLessonUseCase createLessonUseCase;
  final UpdateLessonUseCase updateLessonUseCase;
  final DeleteLessonUseCase deleteLessonUseCase;

  CourseLessonsController({
    required this.courseId,
    required this.getLessonsUseCase,
    required this.createLessonUseCase,
    required this.updateLessonUseCase,
    required this.deleteLessonUseCase,
  });

  final isLoading = false.obs;
  final error = RxnString();
  final lessons = <LessonEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLessons();
  }

  Future<void> loadLessons() async {
    isLoading.value = true;
    error.value = null;
    try {
      final result = await getLessonsUseCase(courseId);
      lessons.assignAll(result);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addLesson({
    required String title,
    required String content,
  }) async {
    final order = lessons.length + 1;
    await createLessonUseCase(
      courseId: courseId,
      title: title,
      content: content,
      order: order,
    );
    await loadLessons();
  }

  Future<void> updateLesson({
    required String id,
    required String title,
    required String content,
    required int order,
  }) async {
    await updateLessonUseCase(
      id: id,
      courseId: courseId,
      title: title,
      content: content,
      order: order,
    );
    await loadLessons();
  }

  Future<void> deleteLesson(String id) async {
    await deleteLessonUseCase(id: id, courseId: courseId);
    await loadLessons();
  }
}
