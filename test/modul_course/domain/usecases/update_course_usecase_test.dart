import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:luar_sekolah_lms/week_7/domain/entities/course_entity.dart';
import 'package:luar_sekolah_lms/week_7/domain/repositories/course_repository.dart';
import 'package:luar_sekolah_lms/week_7/domain/usecases/update_course.dart';

// Mock CourseRepository
class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  late MockCourseRepository mockRepository;
  late UpdateCourseUseCase usecase;

  setUp(() {
    mockRepository = MockCourseRepository();
    usecase = UpdateCourseUseCase(mockRepository);
  });

  test(
    'UpdateCourseUseCase harus memanggil repository.updateCourse dengan parameter yang benar dan mengembalikan CourseEntity',
    () async {
      // ARRANGE
      const tId = 'course-id-123';
      const tName = 'Flutter Advanced';
      final tCategoryTag = ['flutter', 'advanced'];
      const tPrice = '10.00';
      const tRating = '5.0';
      const tThumbnail = 'https://example.com/thumb-adv.png';

      final tUpdatedCourse = CourseEntity(
        id: tId,
        name: tName,
        price: tPrice,
        categoryTag: tCategoryTag,
        thumbnail: tThumbnail,
        rating: tRating,
        createdBy: 'admin',
        createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2025-01-10T00:00:00.000Z'),
      );

      // Atur mock
      when(
        () => mockRepository.updateCourse(
          id: any(named: 'id'),
          name: any(named: 'name'),
          categoryTag: any(named: 'categoryTag'),
          price: any(named: 'price'),
          rating: any(named: 'rating'),
          thumbnail: any(named: 'thumbnail'),
        ),
      ).thenAnswer((_) async => tUpdatedCourse);

      // ACT
      final result = await usecase(
        id: tId,
        name: tName,
        categoryTag: tCategoryTag,
        price: tPrice,
        rating: tRating,
        thumbnail: tThumbnail,
      );

      // ASSERT
      expect(result, tUpdatedCourse);
      expect(result.id, tId);
      expect(result.name, tName);
      expect(result.price, tPrice);

      // Pastikan repository dipanggil dengan parameter yang benar
      verify(
        () => mockRepository.updateCourse(
          id: tId,
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
