import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:luar_sekolah_lms/features/auth_module/presentation/controller/auth_controller.dart';
import 'package:luar_sekolah_lms/features/course_module/domain/entities/course_entity.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/admin/controllers/course_controller.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  double _ratingValue(CourseEntity c) {
    if (c.rating == null) return 0;
    return double.tryParse(c.rating!.trim()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CourseController>();
    final authC = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Admin')),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.error.value != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Terjadi masalah saat memuat data:\n${c.error.value}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: c.loadCourses,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        }

        // Ambil data dari controller admin
        final splCourses = c.splCourses; // dari tab SPL admin
        final prakerjaCourses = c.prakerjaCourses; // dari tab Prakerja admin

        // Gabungkan & unikkan berdasarkan id (jaga-jaga kalau ada yang punya 2 tag)
        final Map<String, CourseEntity> allMap = {};
        for (final course in [...splCourses, ...prakerjaCourses]) {
          allMap[course.id] = course;
        }
        final allCourses = allMap.values.toList();

        final totalCourses = allCourses.length;
        final totalEnrollments = allCourses.fold<int>(
          0,
          (sum, course) => sum + (course.enrollmentCount),
        );

        final ratedCourses = allCourses
            .where((c) => (c.rating != null && c.rating!.trim().isNotEmpty))
            .toList();
        final avgRating = ratedCourses.isEmpty
            ? 0.0
            : ratedCourses
                      .map(_ratingValue)
                      .fold<double>(0.0, (sum, r) => sum + r) /
                  ratedCourses.length;

        // Top 3 berdasarkan rating lalu enrollmentCount
        final topCourses = [...ratedCourses]
          ..sort((a, b) {
            final rb = _ratingValue(b);
            final ra = _ratingValue(a);
            if (rb.compareTo(ra) != 0) return rb.compareTo(ra);
            return b.enrollmentCount.compareTo(a.enrollmentCount);
          });
        final top3 = topCourses.take(3).toList();

        // 🔹 Ambil nama admin dari profile / auth
        final profile = authC.currentUserProfile.value;
        final authUser = authC.currentUser.value;

        String adminName;
        if (profile?.name != null && profile!.name!.trim().isNotEmpty) {
          adminName = profile.name!.trim();
        } else if (authUser?.displayName?.isNotEmpty ?? false) {
          adminName = authUser!.displayName!.trim();
        } else if (authUser?.email?.isNotEmpty ?? false) {
          adminName = authUser!.email!.trim();
        } else {
          adminName = 'Admin';
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 Salam dinamis
              Text(
                'Selamat datang, $adminName 👋',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ringkasan aktivitas kelas hari ini.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),

              // Ringkasan angka (stat cards)
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Total Kelas',
                      value: '$totalCourses',
                      icon: Icons.menu_book_outlined,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Total Enroll',
                      value: '$totalEnrollments',
                      icon: Icons.people_alt_outlined,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Rata-rata Rating',
                      value: ratedCourses.isEmpty
                          ? '-'
                          : avgRating.toStringAsFixed(1),
                      icon: Icons.star_rate_rounded,
                      color: Colors.amber[800]!,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Kelas Dinilai',
                      value: '${ratedCourses.length}',
                      icon: Icons.reviews_outlined,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Distribusi kategori
              const Text(
                'Distribusi Kategori',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CategoryCard(
                      label: 'SPL',
                      count: splCourses.length,
                      color: const Color(0xFF1976D2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CategoryCard(
                      label: 'Prakerja',
                      count: prakerjaCourses.length,
                      color: const Color(0xFF0FA37F),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Top rated courses
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Kelas dengan Rating Tertinggi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.snackbar(
                        'Info',
                        'Gunakan menu "Kursus" untuk mengelola kelas terpopuler.',
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                      );
                    },
                    child: const Text('Kelola Kursus'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (top3.isEmpty)
                const Text(
                  'Belum ada kelas yang memiliki rating.',
                  style: TextStyle(color: Colors.grey),
                )
              else
                Column(
                  children: top3.map((course) {
                    final rating = course.rating ?? '-';
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: const Icon(Icons.menu_book_outlined),
                        ),
                        title: Text(
                          course.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'Rating $rating • ${course.enrollmentCount} peserta',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          // nanti bisa diarahkan ke detail/edit kelas tertentu
                        },
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _CategoryCard({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.label_important_outline, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count kelas',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class _QuickActionChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   const _QuickActionChip({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ActionChip(
//       avatar: Icon(icon, size: 18),
//       label: Text(label),
//       onPressed: onTap,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//     );
//   }
// }
