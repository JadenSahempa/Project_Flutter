import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'new_kelas_result.dart';

class TambahKelasScreen extends StatefulWidget {
  const TambahKelasScreen({super.key});
  @override
  State<TambahKelasScreen> createState() => _TambahKelasScreenState();
}

class _TambahKelasScreenState extends State<TambahKelasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaC = TextEditingController();
  final _hargaC = TextEditingController();
  String? _kategori;

  @override
  void dispose() {
    _namaC.dispose();
    _hargaC.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final nama = _namaC.text.trim();
    final harga = int.tryParse(_hargaC.text.trim());
    if (harga == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Harga tidak valid')));
      return;
    }
    if (_kategori == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih kategori')));
      return;
    }
    Navigator.pop(
      context,
      NewKelasResult(nama: nama, harga: harga, kategori: _kategori!),
    );
  }

  @override
  Widget build(BuildContext context) {
    // (isi form sama seperti punyamu; dipersingkat di sini)
    return Scaffold(
      appBar: AppBar(title: const Text('Informasi Kelas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaC,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nama Kelas',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hargaC,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Harga',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _kategori,
                items: const [
                  DropdownMenuItem(value: 'Prakerja', child: Text('Prakerja')),
                  DropdownMenuItem(value: 'SPL', child: Text('SPL')),
                ],
                onChanged: (v) => setState(() => _kategori = v),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
