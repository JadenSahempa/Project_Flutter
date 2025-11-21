import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_data_source.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remote;
  CourseRepositoryImpl(this.remote);

  @override
  Future<({List<Course> courses, int total, int limit, int offset})> fetch({
    required int limit,
    required int offset,
    List<String> categoryTag = const [],
  }) async {
    final r = await remote.fetch(
      limit: limit,
      offset: offset,
      categoryTag: categoryTag,
    );
    return (
      courses: r.courses.map((e) => e.toEntity()).toList(),
      total: r.total,
      limit: r.limit,
      offset: r.offset,
    );
  }

  @override
  Future<Course> create({
    required String name,
    required List<String> categoryTag,
    String price = '0.00',
    String? rating,
    String? thumbnail,
  }) async => (await remote.create(
    name: name,
    categoryTag: categoryTag,
    price: price,
    rating: rating,
    thumbnail: thumbnail,
  )).toEntity();

  @override
  Future<void> delete(String id) => remote.delete(id);

  @override
  Future<Course> getById(String id) async =>
      (await remote.getById(id)).toEntity();

  @override
  Future<Course> update({
    required String id,
    required String name,
    required List<String> categoryTag,
    required String price,
    String? rating,
    String? thumbnail,
  }) async => (await remote.update(
    id: id,
    name: name,
    categoryTag: categoryTag,
    price: price,
    rating: rating,
    thumbnail: thumbnail,
  )).toEntity();
}
