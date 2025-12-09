import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:luar_sekolah_lms/features/auth_module/presentation/controller/auth_controller.dart';
import 'package:luar_sekolah_lms/features/account_module/screens/edit_profile.dart';
import 'package:luar_sekolah_lms/router/app_router.dart';
import 'package:luar_sekolah_lms/main_shell.dart'; // untuk fadeSlideRoute

import 'package:luar_sekolah_lms/features/course_module/presentation/admin/screens/kelas_terpopuler_screens.dart';
import 'package:luar_sekolah_lms/features/course_module/presentation/admin/screens/admin_reviews_screen.dart';

class AdminAccountScreen extends StatelessWidget {
  const AdminAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            final profile = authC.currentUserProfile.value;
            final authUser = authC.currentUser.value;

            final displayName =
                profile?.name ?? authUser?.displayName ?? 'Admin Luar Sekolah';
            final email =
                profile?.email ?? authUser?.email ?? 'email@contoh.com';
            final role = profile?.role ?? 'admin';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ============= HEADER PROFILE =============
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🔹 Avatar dinamis: pakai photoUrl dari profile
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
                            'Selamat datang kembali,',
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        role.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ============= RINGKASAN PERAN =============
                const Text(
                  'Ringkasan Peran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Icon(
                          Iconsax.shield_tick,
                          color: Colors.deepOrange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kamu adalah Admin',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Kamu bisa membuat, mengedit, dan mem-publish kelas, '
                              'serta memantau rating dan progress belajar peserta.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ============= MENU ADMIN =============
                const Text(
                  'Menu Admin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // BUAT COURSE BARU
                      ListTile(
                        leading: const Icon(Iconsax.add_circle),
                        title: const Text('Buat Course Baru'),
                        subtitle: const Text(
                          'Tambah kelas baru dan atur detail kurikulumnya.',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: const Icon(Iconsax.arrow_right_3),
                        onTap: () {
                          // Sementara: arahkan ke screen pengelolaan kursus,
                          // dari sana admin bisa klik tombol "Tambah" / edit.
                          Navigator.of(
                            context,
                          ).push(fadeSlideRoute(const KelasTerpopulerScreen()));
                        },
                      ),

                      const Divider(height: 0),

                      // KELOLA SEMUA KELAS
                      ListTile(
                        leading: const Icon(Iconsax.category),
                        title: const Text('Kelola Semua Kelas'),
                        subtitle: const Text(
                          'Lihat, edit, publish/non-aktifkan course.',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: const Icon(Iconsax.arrow_right_3),
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(fadeSlideRoute(const KelasTerpopulerScreen()));
                        },
                      ),

                      const Divider(height: 0),

                      // RATING & REVIEW PESERTA
                      ListTile(
                        leading: const Icon(Iconsax.star),
                        title: const Text('Rating & Review Peserta'),
                        subtitle: const Text(
                          'Pantau feedback peserta untuk setiap kursus.',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: const Icon(Iconsax.arrow_right_3),
                        onTap: () {
                          Get.to(() => const AdminReviewsScreen());
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ============= INFORMASI AKUN =============
                const Text(
                  'Informasi Akun',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Iconsax.user_edit),
                        title: const Text('Edit Profil'),
                        subtitle: const Text(
                          'Ubah nama tampilan atau foto profil.',
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: const Icon(Iconsax.arrow_right_3),
                        onTap: () {
                          Navigator.of(
                            context,
                          ).push(fadeSlideRoute(const EditProfileScreen()));
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Icon(Iconsax.lock),
                        title: const Text('Keamanan Akun'),
                        subtitle: const Text(
                          'Ubah password atau atur keamanan login.',
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          Get.snackbar(
                            'Info',
                            'Fitur ganti password bisa dihubungkan ke Firebase Auth.',
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(16),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ============= LOGOUT =============
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
    );
  }
}
