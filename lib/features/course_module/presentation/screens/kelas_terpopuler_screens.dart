import 'package:flutter/material.dart';
import 'package:luar_sekolah_lms/week_7/presentation/widgets/tab_popular.dart';

class KelasTerpopulerScreen extends StatelessWidget {
  const KelasTerpopulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kelas Terpopuler'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Kelas Terpopuler'),
              Tab(text: 'Kelas SPL'),
              Tab(text: 'Kelas Lainnya'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PopularCoursesTab(),
            // SplCoursesTab(),
            // OtherCoursesTab(),
            Center(child: Text('SPL — coming soon')),
            Center(child: Text('Lainnya — coming soon')),
          ],
        ),
      ),
    );
  }
}
