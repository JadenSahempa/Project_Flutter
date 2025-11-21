import '../entities/course.dart';

abstract class CourseRepository {
  Future<({List<Course> courses, int total, int limit, int offset})> fetch({
    required int limit,
    required int offset,
    List<String> categoryTag,
  });

  Future<Course> create({
    required String name,
    required List<String> categoryTag,
    String price,
    String? rating,
    String? thumbnail,
  });

  Future<Course> getById(String id);

  Future<Course> update({
    required String id,
    required String name,
    required List<String> categoryTag,
    required String price,
    String? rating,
    String? thumbnail,
  });

  Future<void> delete(String id);
}
