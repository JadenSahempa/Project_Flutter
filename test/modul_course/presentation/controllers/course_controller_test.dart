import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';

import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_popular_courses.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/delete_course.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/admin/controllers/course_controller.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/repositories/course_repository.dart'; // CoursePage ada di sini

// ---- MOCKS ----
class MockGetPopularCoursesUseCase extends Mock
    implements GetPopularCoursesUseCase {}

class MockDeleteCourseUseCase extends Mock implements DeleteCourseUseCase {}

void main() {
  late MockGetPopularCoursesUseCase mockGetPopularCourses;
  late MockDeleteCourseUseCase mockDeleteCourse;
  late CourseController controller;

  setUp(() {
    Get.testMode = true;

    mockGetPopularCourses = MockGetPopularCoursesUseCase();
    mockDeleteCourse = MockDeleteCourseUseCase();

    controller = CourseController(
      getPopularCourses: mockGetPopularCourses,
      deleteCourseUseCase: mockDeleteCourse,
      defaultTags: const ['prakerja', 'spl'],
    );

    // paging diinisialisasi di onInit() dan LANGSUNG memanggil loadFirstPage()
    controller.onInit();
  });

  group('CourseController - pagination', () {
    test(
      'reload() harus mengambil halaman pertama dan mengisi items',
      () async {
        // ARRANGE
        // supaya hasMore tetap true setelah halaman pertama,
        // kita buat 20 item (pageSize = 20).
        final tCourses = List.generate(
          20,
          (i) => CourseEntity(
            id: '${i + 1}',
            name: 'Course ${i + 1}',
            price: '0.00',
            categoryTag: const ['flutter'],
            thumbnail: null,
            rating: null,
            createdBy: 'admin',
            createdAt: DateTime.parse('2025-01-01T00:00:00.000Z'),
            updatedAt: DateTime.parse('2025-01-02T00:00:00.000Z'),
          ),
        );

        final tPage = CoursePage(courses: tCourses, limit: 20, offset: 0);

        when(
          () => mockGetPopularCourses(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            categoryTag: any(named: 'categoryTag'),
          ),
        ).thenAnswer((_) async => tPage);

        // ACT
        await controller.reload(); // ini memanggil paging.loadFirstPage()

        // ASSERT
        expect(controller.paging.items.length, 20);
        expect(controller.paging.items.first.name, 'Course 1');
        expect(controller.paging.hasMore.value, true);

        // PENTING:
        // getPopularCourses dipanggil:
        // - sekali saat onInit() -> loadFirstPage()
        // - sekali saat reload()
        verify(
          () => mockGetPopularCourses(
            limit: 20,
            offset: 0,
            categoryTag: ['prakerja', 'spl'],
          ),
        ).called(2);
      },
    );

    test('loadMore() harus menambah data ke items', () async {
      // ARRANGE halaman 1 (penuh 20 item supaya hasMore = true)
      final firstCourses = List.generate(
        20,
        (i) => CourseEntity(
          id: '${i + 1}',
          name: 'Course ${i + 1}',
          price: '0.00',
          categoryTag: const ['flutter'],
          thumbnail: null,
          rating: null,
          createdBy: 'admin',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final firstPage = CoursePage(courses: firstCourses, limit: 20, offset: 0);

      // ARRANGE halaman 2 (misal cuma 5 item → setelah ini hasMore = false)
      final secondCourses = List.generate(
        5,
        (i) => CourseEntity(
          id: '2${i + 1}',
          name: 'Course 2${i + 1}',
          price: '0.00',
          categoryTag: const ['flutter'],
          thumbnail: null,
          rating: null,
          createdBy: 'admin',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final secondPage = CoursePage(
        courses: secondCourses,
        limit: 20,
        offset: 20,
      );

      // Stub pemanggilan ke-1 & ke-2 untuk offset=0 (onInit + reload)
      when(
        () => mockGetPopularCourses(
          limit: any(named: 'limit'),
          offset: 0,
          categoryTag: any(named: 'categoryTag'),
        ),
      ).thenAnswer((_) async => firstPage);

      // Stub pemanggilan untuk offset=20 (loadMore)
      when(
        () => mockGetPopularCourses(
          limit: any(named: 'limit'),
          offset: 20,
          categoryTag: any(named: 'categoryTag'),
        ),
      ).thenAnswer((_) async => secondPage);

      // ACT
      await controller.reload(); // page 0 (dipanggil lagi setelah onInit)
      await controller.loadMore(); // page 1

      // ASSERT
      expect(controller.paging.items.length, 25);
      expect(controller.paging.items[0].id, '1');
      expect(controller.paging.items.last.id, '25');
      expect(controller.paging.hasMore.value, false);

      // offset 0: dipanggil 2x (onInit + reload)
      verify(
        () => mockGetPopularCourses(
          limit: 20,
          offset: 0,
          categoryTag: ['prakerja', 'spl'],
        ),
      ).called(2);

      // offset 20: dipanggil 1x (loadMore)
      verify(
        () => mockGetPopularCourses(
          limit: 20,
          offset: 20,
          categoryTag: ['prakerja', 'spl'],
        ),
      ).called(1);
    });

    test(
      'kalau page kosong, hasMore harus false dan loadMore tidak request lagi',
      () async {
        // ARRANGE: reload() → kosong
        final emptyPage = CoursePage(courses: const [], limit: 20, offset: 0);

        when(
          () => mockGetPopularCourses(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
            categoryTag: any(named: 'categoryTag'),
          ),
        ).thenAnswer((_) async => emptyPage);

        // ACT
        await controller.reload();

        // ASSERT awal
        expect(controller.paging.items, isEmpty);
        expect(controller.paging.hasMore.value, false);

        // ACT: coba loadMore lagi
        await controller.loadMore();

        // verify:
        // - onInit() --> 1x offset 0
        // - reload() --> 1x offset 0
        // total 2x untuk offset 0, dan TIDAK ada panggilan tambahan saat loadMore
        verify(
          () => mockGetPopularCourses(
            limit: 20,
            offset: 0,
            categoryTag: ['prakerja', 'spl'],
          ),
        ).called(2);
      },
    );
  });

  group('CourseController - deleteCourse', () {
    test('harus memanggil deleteCourseUseCase', () async {
      // ARRANGE
      const tId = 'course-1';

      when(() => mockDeleteCourse(tId)).thenAnswer((_) async {});

      // stub getPopularCourses supaya reload di dalam controller tidak error,
      // tapi kita tidak perlu verify jumlah panggilannya di sini.
      when(
        () => mockGetPopularCourses(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          categoryTag: any(named: 'categoryTag'),
        ),
      ).thenAnswer(
        (_) async => CoursePage(courses: const [], limit: 20, offset: 0),
      );

      // ACT
      // Di sini akan terjadi pemanggilan LocalNotificationsService.showNotification()
      // yang mengakses plugin. Karena plugin tidak diinisialisasi di unit test,
      // kita tangkap error-nya agar test tetap fokus pada pemanggilan usecase.
      try {
        await controller.deleteCourse(tId);
      } catch (_) {
        // abaikan error dari lokal notifikasi
      }

      // ASSERT: pastikan delete usecase tetap terpanggil
      verify(() => mockDeleteCourse(tId)).called(1);
    });
  });
}
