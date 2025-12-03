import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import 'package:luar_sekolah_lms/features/account_module/screens/edit_profile.dart';
import 'package:luar_sekolah_lms/main_shell.dart';
import 'package:luar_sekolah_lms/router/app_router.dart';
import 'package:luar_sekolah_lms/features/auth_module/presentation/controller/auth_controller.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          // ⬇️ Kita bungkus seluruh isi dengan Obx supaya reactive terhadap perubahan profile/role
          child: Obx(() {
            final profile = authC.currentUserProfile.value;
            final authUser = authC.currentUser.value;

            final displayName =
                profile?.name ?? authUser?.displayName ?? 'User Luar Sekolah';
            final email =
                profile?.email ?? authUser?.email ?? 'email@contoh.com';
            final role = profile?.role ?? 'student'; // default student

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ===== Foto & Nama =====
                const CircleAvatar(
                  radius: 45,
                  // nanti kalau sudah ada avatar di profile bisa diganti
                  backgroundImage: AssetImage('lib/assets/images/person3.jpg'),
                ),
                const SizedBox(height: 12),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),

                // Badge role kecil, supaya keliatan ini student/admin
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: role == 'admin'
                        ? Colors.red.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    role == 'admin' ? 'Admin' : 'Student',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: role == 'admin' ? Colors.red : Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ===== Tombol Edit Profil =====
                ElevatedButton.icon(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),

                // ===== Info tambahan akun =====
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Informasi Akun',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const ListTile(
                  leading: Icon(Iconsax.coin),
                  title: Text('Saldo koinLS'),
                  trailing: Text(
                    '1200',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const ListTile(
                  leading: Icon(Iconsax.star),
                  title: Text('Level Akun'),
                  trailing: Text(
                    'Silver',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                // ===== Menu khusus Admin =====
                if (role == 'admin') ...[
                  const Divider(),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Menu Admin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Iconsax.add_circle),
                    title: const Text('Admin: Buat Course Baru'),
                    trailing: const Icon(Iconsax.arrow_right_3),
                    onTap: () {
                      // TODO: nanti arahkan ke halaman Create Course
                      // Get.to(() => const CreateCourseScreen());
                    },
                  ),
                ],

                const Spacer(),

                OutlinedButton.icon(
                  icon: const Icon(Iconsax.logout),
                  label: const Text('Logout'),
                  onPressed: () async {
                    await authC.logout(); // <- Firebase logout
                    if (!context.mounted) return;
                    AppRouter.goToLoginClearingStack(context);
                  },
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
