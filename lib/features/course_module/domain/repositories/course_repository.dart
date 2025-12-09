import '../entities/course_entity.dart';

class CoursePage {
  final List<CourseEntity> courses;
  final int limit;
  final int offset;

  const CoursePage({
    required this.courses,
    required this.limit,
    required this.offset,
  });
}

abstract class CourseRepository {
  /// List course untuk admin (bisa dipakai user juga nanti).
  Future<List<CourseEntity>> getCourses();

  /// Detail satu course.
  Future<CourseEntity> getCourseById(String id);

  // Future<CoursePage> getCourses({
  //   required int limit,
  //   required int offset,
  //   List<String>? categoryTag,
  // });

  Future<CourseEntity> createCourse({
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
    String? description,
    String status = 'draft',
    required String createdBy,
  });

  Future<CourseEntity> updateCourse({
    required String id,
    required String name,
    required List<String> categoryTag,
    String? price,
    String? rating,
    String? thumbnail,
    String? description,
    String? status,
  });

  Future<void> deleteCourse(String id);
}
