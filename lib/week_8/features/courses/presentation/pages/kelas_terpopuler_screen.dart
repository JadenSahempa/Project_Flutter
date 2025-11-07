import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/course_controller.dart';
import '../bindings/course_binding.dart';
import 'tambah_kelas_screen.dart';
import 'edit_kelas_screen.dart';
import '../widgets/kelas_card.dart';
import 'new_kelas_result.dart';
import 'package:luar_sekolah_lms/utils/format.dart';

// Pastikan CourseBinding dieksekusi sebelum screen ini dipakai.
// Jika pakai GetX routes, set binding di route. Jika manual, panggil CourseBinding().dependencies();

class KelasTerpopulerScreen extends StatelessWidget {
  const KelasTerpopulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // jika tidak lewat routing GetX, manual init binding:
    if (!Get.isRegistered<CourseController>()) {
      CourseBinding().dependencies();
    }
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
            _ListKelasTab(), // ← ini akan pakai controller
            _ComingSoon('SPL'),
            _ComingSoon('Lainnya'),
          ],
        ),
      ),
    );
  }
}

class _ListKelasTab extends StatelessWidget {
  const _ListKelasTab();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CourseController>();

    return SafeArea(
      child: Obx(() {
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // tombol tambah
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () async {
                        // pakai form kamu yang sudah ada:
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TambahKelasScreen(),
                          ),
                        );
                        if (result is NewKelasResult) {
                          await c.create(
                            title: result.nama,
                            price: result.harga,
                            category: result.kategori,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Tambah Kelas'),
                          SizedBox(width: 8),
                          Icon(Icons.add),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // list dari API
            ...c.courses.map(
              (course) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _KelasCard(
                  id: course.id,
                  title: course.name,
                  subtitle:
                      '${course.categoryTag.join(', ')} • ${formatRupiah(course.price)}',
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _KelasCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  const _KelasCard({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CourseController>();

    return Hero(
      tag: id, // ganti tag biar unik by id
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 64,
              height: 64,
              color: const Color(0xFFE6F4EA),
              child: const Icon(Icons.book, size: 28),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(subtitle),
          trailing: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                final r = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditKelasScreen(courseId: id),
                  ),
                );
                if (r is NewKelasResult) {
                  await c.updateCourse(
                    id: id,
                    title: r.nama,
                    price: r.harga,
                    category: r.kategori,
                  );
                }
              } else if (value == 'delete') {
                await c.remove(id);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Kelas dihapus')));
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('Delete'),
                ),
              ),
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Edit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  final String what;
  const _ComingSoon(this.what);
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('Tab $what — coming soon'));
}
