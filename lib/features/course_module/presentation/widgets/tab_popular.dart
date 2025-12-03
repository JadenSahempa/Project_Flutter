import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/course_controller.dart';
import 'course_card.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/screens/course_edit_screens.dart'
    show EditKelasScreen;
import 'package:luar_sekolah_lms/features/course_module/presentation/screens/course_add_screens.dart'
    show TambahKelasScreen;

class PopularCoursesTab extends StatefulWidget {
  const PopularCoursesTab({super.key});

  @override
  State<PopularCoursesTab> createState() => _PopularCoursesTabState();
}

class _PopularCoursesTabState extends State<PopularCoursesTab> {
  late final CourseController c;
  late final ScrollController _scroll;

  @override
  void initState() {
    super.initState();
    c = Get.find<CourseController>(tag: 'popular');

    _scroll = ScrollController();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
        c.loadMore(); // delegasi ke paging.loadNextPage()
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paging = c.paging;

    return SafeArea(
      child: Obx(() {
        // LOADING PERTAMA + TIDAK ADA DATA
        if (paging.isLoadingFirstPage.value && paging.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // ERROR PERTAMA + TIDAK ADA DATA
        if (paging.error.value != null && paging.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Terjadi masalah:\n${paging.error.value}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: paging.loadFirstPage,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        }

        // Loader di bawah list untuk "load more"
        final showBottomLoader =
            paging.isLoadingMore.value && paging.hasMore.value;

        final itemCount =
            1 + // header "Tambah Kelas"
            paging.items.length +
            (showBottomLoader ? 1 : 0); // extra row buat loader bawah

        return RefreshIndicator(
          onRefresh: paging.loadFirstPage,
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: itemCount,
            itemBuilder: (ctx, i) {
              // [0] HEADER: tombol "Tambah Kelas"
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
                              Get.snackbar(
                                'Berhasil',
                                'Course berhasil terbuat',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green.shade50,
                                colorText: Colors.green.shade900,
                                margin: const EdgeInsets.all(12),
                                duration: const Duration(seconds: 2),
                              );

                              // Kalau mau reload list:
                              // await paging.loadFirstPage();
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

              // ITEM TERAKHIR: loader "load more"
              if (showBottomLoader && i == itemCount - 1) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // ITEM COURSE
              final itemIndex = i - 1;
              final item = paging.items[itemIndex];

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

                      // optional: reload data
                      // await paging.loadFirstPage();
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
