import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_progress_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/entities/lesson_entity.dart';

import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_courses.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_lessons.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_course_progress.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_user_enrollments.dart';

import '../../domain/my_course_item.dart';

class MyCoursesController extends GetxController {
  final GetCoursesUseCase getCoursesUseCase;
  final GetLessonsUseCase getLessonsUseCase;
  final GetCourseProgressUseCase getCourseProgressUseCase;
  final GetUserEnrollmentsUseCase getUserEnrollmentsUseCase;

  MyCoursesController({
    required this.getCoursesUseCase,
    required this.getLessonsUseCase,
    required this.getCourseProgressUseCase,
    required this.getUserEnrollmentsUseCase,
  });

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final isLoading = false.obs;
  final error = RxnString();
  final items = <MyCourseItem>[].obs;

  String? get _uid => _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    loadMyCourses();
  }

  Future<void> loadMyCourses() async {
    final uid = _uid;
    if (uid == null) {
      error.value = 'User belum login';
      return;
    }

    isLoading.value = true;
    error.value = null;
    items.clear();

    try {
      // 1. ambil daftar courseId yg di-enroll user
      final enrolledIds = await getUserEnrollmentsUseCase(uid);

      if (enrolledIds.isEmpty) {
        items.clear();
        return;
      }

      final allCourses = await getCoursesUseCase();
      // 1. Extract courseId dari EnrollmentEntity
      final enrolledCourseIds = enrolledIds.map((e) => e.courseId).toList();

      // 2. Filter course yang user enroll
      final myCourses = allCourses
          .where((c) => enrolledCourseIds.contains(c.id))
          .toList(growable: false);

      // 3. untuk tiap course: hitung progress (completed / total lessons)
      final List<MyCourseItem> temp = [];

      for (final course in myCourses) {
        final lessons = await getLessonsUseCase(course.id);
        final List<LessonEntity> lessonList = lessons;

        final CourseProgressEntity? progressEntity =
            await getCourseProgressUseCase(userId: uid, courseId: course.id);

        final completedIds = progressEntity?.completedLessonIds ?? <String>[];

        final total = lessonList.length;
        final done = completedIds.length;
        final progress = total == 0 ? 0.0 : done / total;

        temp.add(MyCourseItem(course: course, progress: progress));
      }

      items.assignAll(temp);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
