import 'package:flutter/material.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/admin/widgets/tab_popular.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/admin/widgets/tab_spl.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/admin/widgets/tab_prakerja.dart';

class KelasTerpopulerScreen extends StatelessWidget {
  const KelasTerpopulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kelola Kelas'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Terpopuler'),
              Tab(text: 'Kelas SPL'),
              Tab(text: 'Prakerja'), // ⬅️ ganti dari "Lainnya"
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PopularCoursesTab(),
            SplCoursesTab(),
            PrakerjaCoursesTab(), // ⬅️ ini kita buat di tab_others.dart
          ],
        ),
      ),
    );
  }
}
