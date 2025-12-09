import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:luar_sekolah_lms/features/account_module/screens/edit_profile.dart';
import 'package:luar_sekolah_lms/main_shell.dart';
import 'package:luar_sekolah_lms/router/app_router.dart';
import 'package:luar_sekolah_lms/features/auth_module/presentation/controller/auth_controller.dart';
import 'package:luar_sekolah_lms/features/mycourse_module/presentation/controllers/my_courses_controller.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    // ⚠️ Jangan pakai Get.find langsung tanpa cek
    MyCoursesController? myC;
    if (Get.isRegistered<MyCoursesController>()) {
      myC = Get.find<MyCoursesController>();
    }

    return DefaultTabController(
      length: 3, // Semua, SPL, Prakerja → dipakai student saja
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              if (myC != null) {
                await myC.loadMyCourses();
              } else {
                await Future.delayed(const Duration(milliseconds: 400));
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                final profile = authC.currentUserProfile.value;
                final authUser = authC.currentUser.value;

                final displayName =
                    profile?.name ??
                    authUser?.displayName ??
                    'User Luar Sekolah';
                final email =
                    profile?.email ?? authUser?.email ?? 'email@contoh.com';
                final role = profile?.role ?? 'student';
                final isAdmin = role == 'admin';

                // Data progress hanya dipakai student
                final items = (!isAdmin && myC != null) ? myC.items : [];
                final totalKelas = items.length;
                final activeKelas = items
                    .where((e) => e.course.status.toLowerCase() == 'published')
                    .length;
                final inactiveKelas = totalKelas - activeKelas;

                // Helper filter progress by tag
                List _filterByTag(String? tag) {
                  if (tag == null) return items;
                  return items.where((e) {
                    final tags = e.course.categoryTag
                        .map((t) => t.toString().toLowerCase())
                        .toList();
                    return tags.contains(tag.toLowerCase());
                  }).toList();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= HEADER PROFILE =================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 🔹 Avatar dinamis pakai photoUrl dari profile
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.teal.shade50,
                          foregroundImage:
                              (profile?.photoUrl != null &&
                                  profile!.photoUrl!.isNotEmpty)
                              ? NetworkImage(profile.photoUrl!)
                              : null,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Semangat Belajarnya,',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // ... badge role tetap sama
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isAdmin
                                ? Colors.red.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isAdmin ? 'Admin' : 'Student',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isAdmin
                                  ? Colors.red
                                  : Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ================= DASHBOARD =================
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF3FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DashboardRowStat(
                            icon: Iconsax.book,
                            label: 'Total Kelas',
                            value: '$totalKelas kelas',
                          ),
                          const SizedBox(height: 8),
                          _DashboardRowStat(
                            icon: Iconsax.play_circle,
                            label: 'Kelas Aktif',
                            value: '$activeKelas kelas',
                          ),
                          const SizedBox(height: 8),
                          _DashboardRowStat(
                            icon: Iconsax.pause_circle,
                            label: 'Kelas Tidak Aktif',
                            value: '$inactiveKelas kelas',
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.snackbar(
                                  'Info',
                                  'Gunakan tab "Kelas" di bawah untuk menelusuri kelas tersedia.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(16),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Telusuri Kelas Tersedia',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ================= PROGRESS KELAS (STUDENT ONLY) =================
                    if (!isAdmin) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progress Kelas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.snackbar(
                                'Info',
                                'Silakan buka tab "Kelasku" di bawah untuk melihat daftar kelas lengkap.',
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                              );
                            },
                            child: const Text('Lihat semua'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Tab filter: Semua, SPL, Prakerja
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(
                              Radius.circular(999),
                            ),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black87,
                          labelStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: const [
                            Tab(text: 'Semua'),
                            Tab(text: 'SPL'),
                            Tab(text: 'Prakerja'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        height: 230,
                        child: (myC == null)
                            ? const Center(
                                child: Text(
                                  'Progress kelas belum tersedia.\nPastikan modul Kelasku sudah diinisialisasi.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              )
                            : TabBarView(
                                children: [
                                  _ProgressListView(
                                    items: items,
                                    isLoading: myC.isLoading.value,
                                  ),
                                  _ProgressListView(
                                    items: _filterByTag('spl'),
                                    isLoading: myC.isLoading.value,
                                  ),
                                  _ProgressListView(
                                    items: _filterByTag('prakerja'),
                                    isLoading: myC.isLoading.value,
                                  ),
                                ],
                              ),
                      ),

                      const SizedBox(height: 24),
                    ],

                    // ================= INFORMASI AKUN =================
                    const Text(
                      'Informasi Akun',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: const [
                          ListTile(
                            leading: Icon(Iconsax.coin),
                            title: Text('Saldo koinLS'),
                            trailing: Text(
                              '1200',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(height: 0),
                          ListTile(
                            leading: Icon(Iconsax.star),
                            title: Text('Level Akun'),
                            trailing: Text(
                              'Silver',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ================= MENU ADMIN (ADMIN ONLY) =================
                    if (isAdmin) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Menu Admin',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Iconsax.add_circle),
                              title: const Text('Buat Course Baru'),
                              trailing: const Icon(Iconsax.arrow_right_3),
                              onTap: () {
                                // TODO: arahkan ke halaman create course admin
                                Get.snackbar(
                                  'Info',
                                  'Gunakan tab "Kelas" untuk mengelola dan membuat course baru.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(16),
                                );
                              },
                            ),
                            const Divider(height: 0),
                            ListTile(
                              leading: const Icon(Iconsax.category),
                              title: const Text('Kelola Kelas (Admin)'),
                              trailing: const Icon(Iconsax.arrow_right_3),
                              onTap: () {
                                Get.snackbar(
                                  'Info',
                                  'Buka tab "Kelas" untuk melihat daftar semua course.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(16),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // ================= BUTTONS: EDIT + LOGOUT =================
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).push(fadeSlideRoute(const EditProfileScreen()));
                        },
                        icon: const Icon(Iconsax.edit),
                        label: const Text('Edit Profil'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Iconsax.logout),
                        label: const Text('Logout'),
                        onPressed: () async {
                          await authC.logout();
                          if (!context.mounted) return;
                          AppRouter.goToLoginClearingStack(context);
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// =============== DASHBOARD ROW STAT ===============

class _DashboardRowStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DashboardRowStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Icon(icon, size: 18, color: Colors.green.shade700),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============== PROGRESS LIST VIEW (HORIZONTAL) ===============

class _ProgressListView extends StatelessWidget {
  final List items;
  final bool isLoading;

  const _ProgressListView({required this.items, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return const Center(child: Text('Belum ada kelas di kategori ini.'));
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        final course = item.course;
        final progress = (item.progress ?? 0.0) as double;
        final progressText = '${(progress * 100).round()}%';

        return SizedBox(
          width: 260,
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Get.snackbar(
                  'Info',
                  'Buka tab "Kelasku" untuk melanjutkan belajar kelas ini.',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail
                    Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                        image: course.thumbnail != null
                            ? DecorationImage(
                                image: NetworkImage(course.thumbnail!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Proses Belajar',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          progressText,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
