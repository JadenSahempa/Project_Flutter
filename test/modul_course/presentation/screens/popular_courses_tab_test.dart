import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:luar_sekolah_lms/features/course_module/presentation/widgets/tab_popular.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/controllers/course_controller.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/get_popular_courses.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/usecases/delete_course.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_entity.dart';
// import PaginationController supaya bisa dipakai di TestCourseController
import 'package:luar_sekolah_lms/features/course_module/presentation/controllers/pagination_controller.dart';

// ---------- MOCKS ----------

class MockGetPopularCoursesUseCase extends Mock
    implements GetPopularCoursesUseCase {}

class MockDeleteCourseUseCase extends Mock implements DeleteCourseUseCase {}

// ---------- TEST CONTROLLER ----------

/// Controller khusus untuk widget test.
/// Dia TIDAK memanggil API beneran, dan kita override loadMore
/// supaya bisa tahu kalau dia kepanggil dari scroll.
class TestCourseController extends CourseController {
  bool loadMoreCalled = false;

  TestCourseController({
    required GetPopularCoursesUseCase getPopularCourses,
    required DeleteCourseUseCase deleteCourseUseCase,
    List<String> defaultTags = const ['prakerja', 'spl'],
  }) : super(
         getPopularCourses: getPopularCourses,
         deleteCourseUseCase: deleteCourseUseCase,
         defaultTags: defaultTags,
       );

  @override
  void onInit() {
    // JANGAN panggil super.onInit();
    // Kita buat PaginationController dummy sendiri,
    // fetchPage tidak akan pernah dipakai di widget test ini.
    paging = PaginationController<CourseEntity>(
      pageSize: 20,
      fetchPage: (page, pageSize) async => <CourseEntity>[],
    );
  }

  @override
  Future<void> loadMore() async {
    loadMoreCalled = true;
    // Tidak perlu super.loadMore() di widget test
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGetPopularCoursesUseCase mockGetPopularCourses;
  late MockDeleteCourseUseCase mockDeleteCourse;
  late TestCourseController controller;

  setUp(() {
    Get.testMode = true;
    Get.reset();

    mockGetPopularCourses = MockGetPopularCoursesUseCase();
    mockDeleteCourse = MockDeleteCourseUseCase();

    controller = TestCourseController(
      getPopularCourses: mockGetPopularCourses,
      deleteCourseUseCase: mockDeleteCourse,
    );

    // Get.put akan memanggil onInit() -> paging kita siap dipakai
    Get.put<CourseController>(controller, tag: 'popular');
  });

  testWidgets('Menampilkan course list saat data tersedia', (
    WidgetTester tester,
  ) async {
    // ARRANGE: isi items secara manual (tidak lewat API)
    final tCourses = [
      CourseEntity(
        id: '1',
        name: 'Flutter Basic',
        price: '0.00',
        categoryTag: const ['mobile'],
        thumbnail: null,
        rating: null,
        createdBy: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    controller.paging.items.assignAll(tCourses);

    // ACT
    await tester.pumpWidget(
      GetMaterialApp(home: Scaffold(body: PopularCoursesTab())),
    );

    await tester.pumpAndSettle();

    // ASSERT
    expect(find.text('Flutter Basic'), findsOneWidget);
    expect(find.text('Tambah Kelas'), findsOneWidget);
  });

  testWidgets('Menampilkan CircularProgressIndicator saat loading pertama', (
    WidgetTester tester,
  ) async {
    // ARRANGE
    controller.paging.isLoadingFirstPage.value = true;

    await tester.pumpWidget(
      GetMaterialApp(home: Scaffold(body: PopularCoursesTab())),
    );

    // ASSERT
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
    'Menampilkan error message saat terjadi error dan tidak ada data',
    (WidgetTester tester) async {
      // ARRANGE
      controller.paging.error.value = 'Terjadi error';
      controller.paging.items.clear();

      await tester.pumpWidget(
        GetMaterialApp(home: Scaffold(body: PopularCoursesTab())),
      );

      await tester.pump();

      // ASSERT
      expect(find.textContaining('Terjadi masalah'), findsOneWidget);
    },
  );

  testWidgets('Memanggil loadMore saat scroll ke bawah', (
    WidgetTester tester,
  ) async {
    // ARRANGE: isi list cukup panjang supaya bisa discroll
    controller.paging.items.assignAll(
      List.generate(
        30,
        (i) => CourseEntity(
          id: '$i',
          name: 'Course $i',
          price: '0.00',
          categoryTag: const ['flutter'],
          thumbnail: null,
          rating: null,
          createdBy: 'admin',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ),
    );

    await tester.pumpWidget(
      GetMaterialApp(home: Scaffold(body: PopularCoursesTab())),
    );

    await tester.pumpAndSettle();

    // ✅ Ambil ScrollableState dari ListView
    final scrollableState = tester.state<ScrollableState>(
      find.byType(Scrollable),
    );

    // ✅ Loncat langsung ke posisi paling bawah
    scrollableState.position.jumpTo(scrollableState.position.maxScrollExtent);

    await tester.pump();

    // ASSERT: pastikan loadMore() di controller kepanggil
    expect(controller.loadMoreCalled, true);
  });
}
