import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:luar_sekolah_lms/week_8/features/courses/domain/use_cases/get_course_by_id_use_case.dart';
import '../../data/providers/course_api_service.dart';
import '../../data/repositories/course_repository_impl.dart';
import '../../domain/use_cases/get_courses_use_case.dart';
import '../../domain/use_cases/create_course_use_case.dart';
import '../../domain/use_cases/update_course_use_case.dart';
import '../../domain/use_cases/delete_course_use_case.dart';
import '../controllers/course_controller.dart';

class CourseBinding extends Bindings {
  @override
  void dependencies() {
    const baseUrl = 'https://ls-lms.zoidify.my.id/'; // base url
    const token = 'default-token'; // token

    final api = CourseApiService(
      client: http.Client(),
      baseUrl: baseUrl,
      token: token,
    );
    final repo = CourseRepositoryImpl(api);

    Get.put(GetCoursesUseCase(repo));
    Get.put(CreateCourseUseCase(repo));
    Get.put(GetCourseByIdUseCase(repo));
    Get.put(UpdateCourseUseCase(repo));
    Get.put(DeleteCourseUseCase(repo));

    Get.put(
      CourseController(
        getUC: Get.find(),
        createUC: Get.find(),
        updateUC: Get.find(),
        deleteUC: Get.find(),
      ),
    );
  }
}
