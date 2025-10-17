import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class KoinLSScreen extends StatelessWidget {
  const KoinLSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('koinLS')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Iconsax.coin, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Feature Coming Soon',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Saldo dan riwayat koin akan tampil di sini.\nSekarang masih dummy page.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Iconsax.arrow_left_2),
                label: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
