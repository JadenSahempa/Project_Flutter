import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// SESUAIKAN dengan struktur project-mu
import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/repositories/course_repository.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_course_detail.dart';

// Mock untuk CourseRepository
class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  late MockCourseRepository mockRepository;
  late GetCourseDetailUseCase usecase;

  setUp(() {
    mockRepository = MockCourseRepository();
    usecase = GetCourseDetailUseCase(mockRepository);
  });

  test(
    'harus memanggil repository.getCourseById dengan id yang benar dan mengembalikan CourseEntity',
    () async {
      // ARRANGE
      const tId = 'course-id-123';

      final tCourse = CourseEntity(
        id: tId,
        name: 'Flutter Basic',
        price: '0.00',
        categoryTag: ['flutter', 'mobile'],
        thumbnail: null,
        rating: null,
        createdBy: 'admin',
        createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2025-01-02T00:00:00.000Z'),
      );

      // Atur mock: kalau getCourseById dipanggil dengan tId, balikin tCourse
      when(
        () => mockRepository.getCourseById(tId),
      ).thenAnswer((_) async => tCourse);

      // ACT
      final result = await usecase(tId);

      // ASSERT
      expect(result, tCourse);
      expect(result.id, tId);
      expect(result.name, 'Flutter Basic');

      // Pastikan dipanggil dengan id yang benar
      verify(() => mockRepository.getCourseById(tId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
