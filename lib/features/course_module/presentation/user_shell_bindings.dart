import 'package:get/get.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_courses.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_lessons.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/enroll_in_course.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_user_enrollments.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_course_progress.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/toggle_lesson_completed.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/unenroll_from_course.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_reviews.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_user_review.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/upsert_review.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/delete_review.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/user/controllers/user_course_controller.dart';

class UserShellBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserCourseController>(
      () => UserCourseController(
        getCoursesUseCase: Get.find<GetCoursesUseCase>(),
        getLessonsUseCase: Get.find<GetLessonsUseCase>(),
        enrollInCourseUseCase: Get.find<EnrollInCourseUseCase>(),
        getUserEnrollmentsUseCase: Get.find<GetUserEnrollmentsUseCase>(),
        getCourseProgressUseCase: Get.find<GetCourseProgressUseCase>(),
        toggleLessonCompletedUseCase: Get.find<ToggleLessonCompletedUseCase>(),
        unenrollFromCourseUseCase: Get.find<UnenrollFromCourseUseCase>(),
        getReviewsUseCase: Get.find<GetReviewsUseCase>(),
        getUserReviewUseCase: Get.find<GetUserReviewUseCase>(),
        upsertReviewUseCase: Get.find<UpsertReviewUseCase>(),
        deleteReviewUseCase: Get.find<DeleteReviewUseCase>(),
      ),
      fenix: true,
    );
  }
}
