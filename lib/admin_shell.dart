import 'package:flutter/material.dart';
import 'package:luar_sekolah_lms/features/account_module/screens/akun_admin.dart';
// import 'package:get/get.dart';
import 'package:luar_sekolah_lms/features/auth_module/presentation/screens/admin_dashboard_screen.dart';

import 'package:luar_sekolah_lms/features/course_module/presentation/admin/screens/kelas_terpopuler_screens.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/course_bindings.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const AdminDashboardScreen(),
    const KelasTerpopulerScreen(),
    const AdminAccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    CourseBindings().dependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Kursus'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
