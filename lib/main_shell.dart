import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:luar_sekolah_lms/week_3/screens/home_screen.dart';
import 'week_5/screens/kelasku.dart';
// import 'koin_ls.dart';
import 'week_5/screens/akun.dart';
import 'week_7/presentation/screens/kelas_terpopuler_screens.dart';
import 'package:luar_sekolah_lms/week_6/screens/todo_crud_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Controller buat animasi pindah tab
  late final PageController _controller;
  int _currentIndex = 0;

  // Urutan halaman sama seperti urutan icon di BottomNav
  late final List<Widget> _pages = const [
    HomeScreen(), // Beranda
    KelasTerpopulerScreen(),
    KelaskuScreen(),
    // KoinLSScreen(),
    AkunScreen(),
    TodoCrudScreen(),
  ];

  @override
  void initState() {
    super.initState();
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
        // type: BottomNavigationBarType.fixed,
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

          // BottomNavigationBarItem(
          //   icon: Icon(Iconsax.coin),
          //   activeIcon: Icon(Iconsax.coin5, size: 28),
          //   label: 'koinLS',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            activeIcon: Icon(Iconsax.user_square, size: 28),
            label: 'Akun',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.video),
            activeIcon: Icon(Iconsax.video5, size: 28),
            label: 'todos',
          ),
        ],
      ),
    );
  }
}

//
// Helper untuk animasi transisi antar route
//
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
