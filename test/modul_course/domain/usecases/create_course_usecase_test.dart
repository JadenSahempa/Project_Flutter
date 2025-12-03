import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/repositories/course_repository.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/create_course.dart';

// Mock CourseRepository
class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  late MockCourseRepository mockRepository;
  late CreateCourseUseCase usecase;

  setUp(() {
    mockRepository = MockCourseRepository();
    usecase = CreateCourseUseCase(mockRepository);
  });

  test(
    'CreateCourseUseCase harus memanggil repository.createCourse dengan parameter yang benar dan mengembalikan CourseEntity',
    () async {
      // ARRANGE
      const tName = 'Flutter Basic';
      final tCategoryTag = ['flutter', 'mobile'];
      const tPrice = '0.00';
      const tRating = '4.5';
      const tThumbnail = 'https://example.com/thumb.png';

      final tCourse = CourseEntity(
        id: '1',
        name: tName,
        price: tPrice,
        categoryTag: tCategoryTag,
        thumbnail: tThumbnail,
        rating: tRating,
        createdBy: 'admin',
        createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2025-01-02T00:00:00.000Z'),
      );

      // Atur mock: kalau createCourse dipanggil, balikin tCourse
      when(
        () => mockRepository.createCourse(
          name: any(named: 'name'),
          categoryTag: any(named: 'categoryTag'),
          price: any(named: 'price'),
          rating: any(named: 'rating'),
          thumbnail: any(named: 'thumbnail'),
        ),
      ).thenAnswer((_) async => tCourse);

      // ACT
      final result = await usecase(
        name: tName,
        categoryTag: tCategoryTag,
        price: tPrice,
        rating: tRating,
        thumbnail: tThumbnail,
      );

      // ASSERT
      expect(result, tCourse);
      expect(result.name, tName);
      expect(result.categoryTag, tCategoryTag);

      // Pastikan repository dipanggil dengan parameter yang benar
      verify(
        () => mockRepository.createCourse(
          name: tName,
          categoryTag: tCategoryTag,
          price: tPrice,
          rating: tRating,
          thumbnail: tThumbnail,
        ),
      ).called(1);

      verifyNoMoreInteractions(mockRepository);
    },
  );
}
