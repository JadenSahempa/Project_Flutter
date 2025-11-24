import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:luar_sekolah_lms/week_7/services/course_api_service.dart';
import '../controllers/course_controller.dart';
import 'course_card.dart';
import 'package:luar_sekolah_lms/week_7/presentation/screens/course_edit_screens.dart'
    show EditKelasScreen;
import 'package:luar_sekolah_lms/week_7/presentation/screens/course_add_screens.dart'
    show TambahKelasScreen;

class PopularCoursesTab extends StatelessWidget {
  const PopularCoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CourseController>(tag: 'popular');

    final scroll = ScrollController();
    scroll.addListener(() {
      if (scroll.position.pixels >= scroll.position.maxScrollExtent - 200) {
        c.loadMore();
      }
    });

    return SafeArea(
      child: Obx(() {
        if (c.loading.value && c.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.error.value != null && c.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Terjadi masalah:\n${c.error.value}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: c.reload,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => c.reload(),
          child: ListView.builder(
            controller: scroll,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: c.items.length + 1,
            itemBuilder: (ctx, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Get.to(
                              () => const TambahKelasScreen(),
                            );
                            if (result == true) {
                              // kalau submit() sudah memanggil listCtrl.reload(), bagian ini cukup snackbar saja
                              Get.snackbar(
                                'Berhasil',
                                'Course berhasil terbuat',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green.shade50,
                                colorText: Colors.green.shade900,
                                margin: const EdgeInsets.all(12),
                                duration: const Duration(seconds: 2),
                              );

                              // jika kamu TIDAK reload dari controller, panggil ini:
                              // c.reload();
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
                );
              }

              final item = c.items[i - 1];
              final tags = item.categoryTag;
              final price = item.price == '0.00'
                  ? 'Gratis'
                  : 'Rp ${item.price}';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CourseCard(
                  title: item.name,
                  tags: tags,
                  priceText: price,
                  thumbnailUrl: item.thumbnail,
                  rating: item.rating,

                  // di PopularCoursesTab, saat membuat CourseCard
                  onEdit: () async {
                    final result = await Get.to(
                      () => EditKelasScreen(courseId: item.id),
                    );

                    if (result == true) {
                      Get.snackbar(
                        'Berhasil',
                        'Course berhasil diperbarui',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green.shade50,
                        colorText: Colors.green.shade900,
                        margin: const EdgeInsets.all(12),
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },

                  onDelete: () async {
                    final ok = await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text('Hapus Kelas'),
                        content: Text('Yakin ingin menghapus "${item.name}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text('Batal'),
                          ),
                          ElevatedButton(
                            onPressed: () => Get.back(result: true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );

                    if (ok == true) {
                      try {
                        await c.deleteCourse(item.id);
                        // opsi 2 (instan): hapus lokal lalu setState via Rx:
                        // c.items.removeWhere((x) => x.id == item.id);

                        Get.snackbar(
                          'Berhasil',
                          'Course berhasil dihapus',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      } catch (e) {
                        Get.snackbar(
                          'Gagal',
                          e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    }
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
