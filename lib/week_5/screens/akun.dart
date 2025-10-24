import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:luar_sekolah_lms/week_4/screens/edit_profile.dart';
import '../../main_shell.dart';
import 'package:luar_sekolah_lms/router/app_router.dart';
import 'package:luar_sekolah_lms/utils/shared_helper.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageHelper.instance;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ===== Foto & Nama =====
              const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('lib/assets/images/person3.jpg'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ahmad Sahroni',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const Text(
                'sahroni@example.com',
                style: TextStyle(color: Colors.grey),
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
              const Spacer(),

              OutlinedButton.icon(
                icon: const Icon(Iconsax.logout),
                label: const Text('Logout'),
                onPressed: () async {
                  await storage.logout();
                  if (!context.mounted) return;
                  AppRouter.goToLoginClearingStack(
                    context,
                  ); // bersihkan stack → balik login
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
