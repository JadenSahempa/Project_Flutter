import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:luar_sekolah_lms/week_7/domain/repositories/course_repository.dart';
import 'package:luar_sekolah_lms/week_7/domain/usecases/delete_course.dart';

class MockCourseRepository extends Mock implements CourseRepository {}

void main() {
  late MockCourseRepository mockRepository;
  late DeleteCourseUseCase usecase;

  setUp(() {
    mockRepository = MockCourseRepository();
    usecase = DeleteCourseUseCase(mockRepository);
  });

  test(
    'harus memanggil repository.deleteCourse dengan id yang benar',
    () async {
      const tId = 'course-id-123';

      when(() => mockRepository.deleteCourse(tId)).thenAnswer((_) async {});

      // act
      await usecase(tId);

      verify(() => mockRepository.deleteCourse(tId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
