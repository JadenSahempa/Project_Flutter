import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 👉 SESUAIKAN dengan package project-mu:
import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/repositories/course_repository.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_popular_courses.dart';

// 1. Bikin mock untuk CourseRepository
class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  late MockCourseRepository mockRepository;
  late GetPopularCoursesUseCase usecase;

  setUp(() {
    mockRepository = MockCourseRepository();
    usecase = GetPopularCoursesUseCase(mockRepository);
  });

  test(
    'harus mengembalikan CoursePage dari repository dan memanggil repo dengan benar',
    () async {
      // ARRANGE (siapkan data & perilaku mock)
      const tLimit = 10;
      const tOffset = 0;
      final tCategoryTag = ['flutter'];

      final tCourses = [
        CourseEntity(
          id: '1',
          name: 'Flutter Basic',
          price: '0.00',
          categoryTag: ['flutter', 'mobile'],
          thumbnail: null,
          rating: null,
          createdBy: 'admin',
          createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
          updatedAt: DateTime.parse('2025-01-02T00:00:00.000Z'),
        ),
      ];

      final tCoursePage = CoursePage(
        courses: tCourses,
        limit: tLimit,
        offset: tOffset,
      );

      // Atur mock: kalau getCourses dipanggil, balikin tCoursePage
      when(
        () => mockRepository.getCourses(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          categoryTag: any(named: 'categoryTag'),
        ),
      ).thenAnswer((_) async => tCoursePage);

      // ACT (panggil usecase)
      final result = await usecase(
        limit: tLimit,
        offset: tOffset,
        categoryTag: tCategoryTag,
      );

      // ASSERT (cek hasil & verify pemanggilan)
      expect(result, tCoursePage);
      expect(result.courses.length, 1);
      expect(result.courses.first.name, 'Flutter Basic');

      // Pastikan repo dipanggil dengan parameter yang benar
      verify(
        () => mockRepository.getCourses(
          limit: tLimit,
          offset: tOffset,
          categoryTag: tCategoryTag,
        ),
      ).called(1);

      verifyNoMoreInteractions(mockRepository);
    },
  );
}
