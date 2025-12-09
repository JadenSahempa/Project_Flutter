import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:luar_sekolah_lms/features/auth_module/presentation/screens/home_screen.dart';
import 'package:luar_sekolah_lms/features/mycourse_module/presentation/screens/kelasku.dart';
import 'package:luar_sekolah_lms/features/account_module/screens/akun_student.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/user/screens/course_list_screen.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/course_bindings.dart';
import 'package:luar_sekolah_lms/features/mycourse_module/presentation/controllers/my_courses_controller.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/user_shell_bindings.dart';

class MainShell extends StatefulWidget {
  /// index tab yang mau dibuka pertama kali
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Controller buat animasi pindah tab
  late final PageController _controller;

  // jangan hardcode 0, nanti di-init pakai widget.initialIndex
  late int _currentIndex;

  // Urutan halaman sama seperti urutan icon di BottomNav
  late final List<Widget> _pages = [
    const HomeScreen(), // index 0 - Beranda
    const CourseListScreen(), // index 1 - Kelas
    const KelaskuScreen(), // index 2 - Kelasku (SEKARANG berisi 2 tab: Kelas & Todo)
    const AkunScreen(), // index 3 - Akun
  ];

  @override
  void initState() {
    super.initState();

    // 1) set index awal dari parameter widget
    _currentIndex = widget.initialIndex;

    // 2) binding semua usecase untuk Course module
    CourseBindings().dependencies();
    UserShellBindings().dependencies();

    // 3) daftarkan MyCoursesController (dipakai waktu enroll/unenroll)
    Get.lazyPut(
      () => MyCoursesController(
        getCoursesUseCase: Get.find(),
        getLessonsUseCase: Get.find(), // ⬅ tambahan
        getUserEnrollmentsUseCase: Get.find(),
        getCourseProgressUseCase: Get.find(),
      ),
    );

    // 4) inisialisasi PageController pakai _currentIndex
    _controller = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (i) => setState(() => _currentIndex = i),
        children: _pages,
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (i) {
          setState(() => _currentIndex = i);
          _controller.animateToPage(
            i,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_1),
            activeIcon: Icon(Iconsax.home_2, size: 28),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.category),
            activeIcon: Icon(Iconsax.category5, size: 28),
            label: 'Kelas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.video),
            activeIcon: Icon(Iconsax.video5, size: 28),
            label: 'Kelasku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            activeIcon: Icon(Iconsax.user_square, size: 28),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}

// Helper untuk animasi transisi antar route
Route fadeSlideRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      final offset = Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(position: offset, child: child),
      );
    },
  );
}
