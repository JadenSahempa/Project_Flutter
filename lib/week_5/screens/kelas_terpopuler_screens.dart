import 'package:flutter/material.dart';

class KelasTerpopulerScreen extends StatelessWidget {
  const KelasTerpopulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kelas Terpopuler'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: 'Kelas Terpopuler',
                // icon: Icon(Icons.local_fire_department),
              ),
              Tab(
                text: 'Kelas SPL',
                //  icon: Icon(Icons.verified_user_outlined)
              ),
              Tab(
                text: 'Kelas Lainnya',
                //  icon: Icon(Icons.apps_outlined)
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [
                  _ListKelasTab(), // tab 1
                  const _ComingSoon('SPL'), // tab 2
                  const _ComingSoon('Lainnya'), // tab 3
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====== Contoh konten Tab 1: list kartu kelas ======
class _ListKelasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      2,
      (i) => 'Teknik Pemilahan dan Pengolahan Sampah',
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // <— ini kuncinya
              children: [
                SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tambah Kelas ditekan')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
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

          ...items.map(
            (title) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _KelasCard(title: title),
            ),
          ),
        ],
      ),
    );
  }
}

class _KelasCard extends StatelessWidget {
  final String title;
  const _KelasCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: title, // <— tag unik untuk Hero
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
          subtitle: const Text("Prakerja • SPL"),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _EditKelasScreen(title: title),
                  ),
                );
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

class _EditKelasScreen extends StatefulWidget {
  final String title;
  const _EditKelasScreen({required this.title});

  @override
  State<_EditKelasScreen> createState() => _EditKelasScreenState();
}

class _EditKelasScreenState extends State<_EditKelasScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaC;
  final _hargaC = TextEditingController();
  String? _kategori; // 'Prakerja' atau 'SPL'

  @override
  void initState() {
    super.initState();
    _namaC = TextEditingController(text: widget.title); // prefill dari card
  }

  @override
  void dispose() {
    _namaC.dispose();
    _hargaC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informasi Kelas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==== Hero header (match dengan leading di card) ====
                Hero(
                  tag: widget.title,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 120,
                      color: const Color(0xFFE6F4EA),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.book,
                        size: 64,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ==== Kartu berisi form seperti mockup ====
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Informasi Kelas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Nama Kelas
                          const Text('Nama Kelas'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _namaC,
                            decoration: const InputDecoration(
                              hintText: 'e.g Marketing Communication',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Nama wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Harga Kelas
                          const Text('Harga Kelas'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _hargaC,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'e.g 1.000.000',
                              helperText: 'Masukkan dalam bentuk angka',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Kategori Kelas
                          const Text('Kategori Kelas'),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _kategori,
                            items: const [
                              DropdownMenuItem(
                                value: 'Prakerja',
                                child: Text('Prakerja'),
                              ),
                              DropdownMenuItem(
                                value: 'SPL',
                                child: Text('SPL'),
                              ),
                            ],
                            onChanged: (v) => setState(() => _kategori = v),
                            decoration: const InputDecoration(
                              hintText: 'Pilih Prakerja atau SPL',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => (v == null)
                                ? 'Pilih salah satu kategori'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Thumbnail Kelas
                          const Text('Thumbnail Kelas'),
                          const SizedBox(height: 6),
                          OutlinedButton.icon(
                            onPressed: () {
                              // TODO: implementasi file picker
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Upload Foto ditekan'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.image_outlined),
                            label: const Text('Upload Foto'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Tombol aksi
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // TODO: simpan ke backend
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Perubahan disimpan'),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0FA958),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Simpan Perubahan'),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF0FA958),
                              side: const BorderSide(color: Color(0xFF0FA958)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Kembali'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeFilled extends StatelessWidget {
  final String text;
  const _BadgeFilled(this.text);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFE6F4EA),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Color(0xFF0FA958),
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  );
}

class _BadgeOutlined extends StatelessWidget {
  final String text;
  const _BadgeOutlined(this.text);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFF0FA958)),
      borderRadius: BorderRadius.circular(24),
    ),
    child: const Text(
      'SPL',
      style: TextStyle(
        color: Color(0xFF0FA958),
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    ),
  );
}

class _ComingSoon extends StatelessWidget {
  final String what;
  const _ComingSoon(this.what);
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('Tab $what — coming soon'));
}
