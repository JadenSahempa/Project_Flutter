import 'package:flutter/material.dart';
import 'package:luar_sekolah_lms/features/account_module/screens/akun.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    const AdminDashboardScreen(),
    const AdminCourseListScreen(),
    const AkunScreen(), // Akun yang sama, tapi akan nunjukin role: Admin
  ];

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

/// Placeholder untuk dashboard admin
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Dashboard Admin\n(nanti isi ringkasan, statistik, dsb)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Placeholder untuk kelola course
class AdminCourseListScreen extends StatelessWidget {
  const AdminCourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Kursus')),
      body: const Center(
        child: Text(
          'Daftar kursus untuk Admin\n(nanti dihubungkan ke Course module)',
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: arahkan ke halaman CreateCourse
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
