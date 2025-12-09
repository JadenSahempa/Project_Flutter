import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ===== Course (kelas utama) =====
import 'package:luar_sekolah_lms/features/course_module/data/repositories/course_repository_firestore.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/repositories/course_repository.dart';

import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_courses.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/create_course.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_course_detail.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_user_review.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/update_course.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/delete_course.dart';

import 'package:luar_sekolah_lms/features/course_module/presentation/admin/controllers/course_controller.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/admin/controllers/courseAddController.dart';
// CourseEditController dibuat di screen karena butuh courseId

// ===== Lesson (materi per bab) =====
import 'package:luar_sekolah_lms/features/course_module/data/repositories/lesson_repository_firestore.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/repositories/lesson_repository.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_lessons.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/create_lesson.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/update_lesson.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/delete_lesson.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/admin/controllers/course_lessons_controller.dart';

// ===== Enrollment (user ambil kelas) =====
import 'package:luar_sekolah_lms/features/course_module/data/repositories/enrollment_repository_firestore.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/repositories/enrollment_repository.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/enroll_in_course.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/unenroll_from_course.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_user_enrollments.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/is_user_enrolled.dart';

// ===== Progress (progres belajar per lesson) =====
import 'package:luar_sekolah_lms/features/course_module/data/repositories/course_progress_repository_firestore.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/repositories/course_progress_repository.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_course_progress.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/toggle_lesson_completed.dart';

// ===== Review =====
import 'package:luar_sekolah_lms/features/course_module/data/repositories/review_repository_firestore.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/repositories/review_repository.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_reviews.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/upsert_review.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/delete_review.dart';

/// Bindings utama untuk semua dependency module Course:
/// - Course (data kelas)
/// - Lesson (materi per bab)
/// - Enrollment (user yang mengambil kelas)
/// - Progress (progres belajar per materi)
class CourseBindings extends Bindings {
  @override
  void dependencies() {
    // 1) CORE: Firestore
    //    Disimpan sebagai singleton (fenix: true → kalau tak terpakai dan dihapus,
    //    bisa dibuat ulang otomatis saat dibutuhkan lagi).
    Get.lazyPut<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
      fenix: true,
    );

    // =====================================================
    // 2) COURSE: Data Kelas (Admin & User)
    // =====================================================

    // 2.1) Repository Course
    Get.lazyPut<CourseRepository>(
      () => CourseRepositoryFirestore(Get.find<FirebaseFirestore>()),
      fenix: true,
    );

    // 2.2) Usecase Course
    Get.lazyPut<GetCoursesUseCase>(
      () => GetCoursesUseCase(Get.find<CourseRepository>()),
      fenix: true,
    );
    Get.lazyPut<CreateCourseUseCase>(
      () => CreateCourseUseCase(Get.find<CourseRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetCourseDetailUseCase>(
      () => GetCourseDetailUseCase(Get.find<CourseRepository>()),
      fenix: true,
    );
    Get.lazyPut<UpdateCourseUseCase>(
      () => UpdateCourseUseCase(Get.find<CourseRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteCourseUseCase>(
      () => DeleteCourseUseCase(Get.find<CourseRepository>()),
      fenix: true,
    );

    // 2.3) Controller Admin untuk kelola list/publish/delete Course
    Get.lazyPut<CourseController>(
      () => CourseController(
        getCoursesUseCase: Get.find<GetCoursesUseCase>(),
        deleteCourseUseCase: Get.find<DeleteCourseUseCase>(),
      ),
      fenix: true,
    );

    // 2.4) Controller Admin untuk Tambah Course
    Get.lazyPut<CourseAddController>(
      () => CourseAddController(
        createCourseUseCase: Get.find<CreateCourseUseCase>(),
      ),
      fenix: true,
    );
    // NOTE: CourseEditController di-create di screen EditKelasScreen,
    // karena butuh parameter courseId dari Get.arguments.

    // =====================================================
    // 3) LESSON: Materi per Bab di dalam Course
    // =====================================================

    // 3.1) Repository Lesson
    Get.lazyPut<LessonRepository>(
      () => LessonRepositoryFirestore(Get.find<FirebaseFirestore>()),
      fenix: true,
    );

    // 3.2) Usecase Lesson
    Get.lazyPut<GetLessonsUseCase>(
      () => GetLessonsUseCase(Get.find<LessonRepository>()),
      fenix: true,
    );
    Get.lazyPut<CreateLessonUseCase>(
      () => CreateLessonUseCase(Get.find<LessonRepository>()),
      fenix: true,
    );
    Get.lazyPut<UpdateLessonUseCase>(
      () => UpdateLessonUseCase(Get.find<LessonRepository>()),
      fenix: true,
    );
    Get.lazyPut<DeleteLessonUseCase>(
      () => DeleteLessonUseCase(Get.find<LessonRepository>()),
      fenix: true,
    );

    // 3.3) Controller Admin untuk Kelola Materi per Course
    //
    // Catatan:
    // - Controller ini butuh courseId dari Get.arguments.
    // - Artinya, bindings ini cocok dipakai di GetPage yang khusus
    //   untuk layar "ManageLessonsScreen" (bukan dipanggil manual di main_shell).
    Get.lazyPut<CourseLessonsController>(() {
      final args = Get.arguments;
      final String courseId;
      if (args is String) {
        courseId = args;
      } else if (args is Map && args['courseId'] is String) {
        courseId = args['courseId'] as String;
      } else {
        throw Exception('courseId tidak ditemukan di Get.arguments');
      }

      return CourseLessonsController(
        courseId: courseId,
        getLessonsUseCase: Get.find<GetLessonsUseCase>(),
        createLessonUseCase: Get.find<CreateLessonUseCase>(),
        updateLessonUseCase: Get.find<UpdateLessonUseCase>(),
        deleteLessonUseCase: Get.find<DeleteLessonUseCase>(),
      );
    }, fenix: true);

    // =====================================================
    // 4) ENROLLMENT: User Mengambil / Mendaftar Kelas
    // =====================================================

    // 4.1) Repository Enrollment
    Get.lazyPut<EnrollmentRepository>(
      () => EnrollmentRepositoryFirestore(Get.find<FirebaseFirestore>()),
      fenix: true,
    );

    // 4.2) Usecase Enrollment (dipakai di sisi User)
    Get.lazyPut<EnrollInCourseUseCase>(
      () => EnrollInCourseUseCase(Get.find<EnrollmentRepository>()),
      fenix: true,
    );
    Get.lazyPut<UnenrollFromCourseUseCase>(
      () => UnenrollFromCourseUseCase(Get.find<EnrollmentRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetUserEnrollmentsUseCase>(
      () => GetUserEnrollmentsUseCase(Get.find<EnrollmentRepository>()),
      fenix: true,
    );
    Get.lazyPut<IsUserEnrolledUseCase>(
      () => IsUserEnrolledUseCase(Get.find<EnrollmentRepository>()),
      fenix: true,
    );

    // =====================================================
    // 5) PROGRESS: Progress Belajar per Lesson di dalam Course
    // =====================================================

    // 5.1) Repository Course Progress
    Get.lazyPut<CourseProgressRepository>(
      () => CourseProgressRepositoryFirestore(Get.find<FirebaseFirestore>()),
      fenix: true,
    );

    // 5.2) Usecase Progress
    Get.lazyPut<GetCourseProgressUseCase>(
      () => GetCourseProgressUseCase(Get.find<CourseProgressRepository>()),
      fenix: true,
    );
    Get.lazyPut<ToggleLessonCompletedUseCase>(
      () => ToggleLessonCompletedUseCase(Get.find<CourseProgressRepository>()),
      fenix: true,
    );

    // =========================================
    // 6. Review & Rating
    // =========================================
    Get.lazyPut<ReviewRepository>(
      () => ReviewRepositoryFirestore(Get.find<FirebaseFirestore>()),
      fenix: true,
    );

    Get.lazyPut<GetReviewsUseCase>(
      () => GetReviewsUseCase(Get.find<ReviewRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetUserReviewUseCase>(
      () => GetUserReviewUseCase(Get.find<ReviewRepository>()),
      fenix: true,
    );

    Get.lazyPut<UpsertReviewUseCase>(
      () => UpsertReviewUseCase(Get.find<ReviewRepository>()),
      fenix: true,
    );

    Get.lazyPut<DeleteReviewUseCase>(
      () => DeleteReviewUseCase(Get.find<ReviewRepository>()),
      fenix: true,
    );
  }
}
