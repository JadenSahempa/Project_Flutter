class NewKelasResult {
  final String nama;
  final int harga;
  final String kategori;
  final String? thumbnail;
  const NewKelasResult({
    required this.nama,
    required this.harga,
    required this.kategori,
    this.thumbnail,
  });
}
