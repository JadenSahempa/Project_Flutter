import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_entity.dart';

class MyCourseItem {
  final CourseEntity course;
  final double progress; // 0.0 - 1.0

  MyCourseItem({required this.course, required this.progress});
}
