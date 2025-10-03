import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageC = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF0FA37F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                decoration: const BoxDecoration(color: green),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(
                        'lib/assets/images/person.jpg',
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo,',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          Text(
                            'Ahmad Sahroni 👋',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                transform: Matrix4.translationValues(0, -18, 0),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000), // halus
                        blurRadius: 14,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: PageView(
                            controller: _pageC,
                            onPageChanged: (i) => setState(() => _page = i),
                            children: [
                              // banner 1
                              Stack(
                                children: [
                                  const Positioned.fill(
                                    child: Image(
                                      image: AssetImage(
                                        'lib/assets/images/banner_1.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.9),
                                        foregroundColor: Colors.black87,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Text('IKUTAN SEKARANG'),
                                    ),
                                  ),
                                ],
                              ),
                              // banner 2
                              Stack(
                                children: [
                                  const Positioned.fill(
                                    child: Image(
                                      image: AssetImage(
                                        'lib/assets/images/banner_2.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.9),
                                        foregroundColor: Colors.black87,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Text('PELAJARI'),
                                    ),
                                  ),
                                ],
                              ),
                              // banner 3
                              Stack(
                                children: [
                                  const Positioned.fill(
                                    child: Image(
                                      image: AssetImage(
                                        'lib/assets/images/banner_3.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.9),
                                        foregroundColor: Colors.black87,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Text('DAFTAR'),
                                    ),
                                  ),
                                ],
                              ),
                              // banner 4
                              Stack(
                                children: [
                                  const Positioned.fill(
                                    child: Image(
                                      image: AssetImage(
                                        'lib/assets/images/banner_4.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.9),
                                        foregroundColor: Colors.black87,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Text('LIHAT DETAIL'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // dots: aktif hijau solid, lainnya ring abu-abu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (i) {
                          final active = i == _page;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: active ? green : Colors.transparent,
                              border: Border.all(
                                color: active ? green : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Program dari Luarsekolah',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 84,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.work_outline,
                                  size: 26,
                                  color: Colors.black87,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Prakerja',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 84,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outline,
                                  size: 26,
                                  color: Colors.black87,
                                ),
                                SizedBox(height: 6),
                                Text('magang+', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 84,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.subscriptions_outlined,
                                  size: 26,
                                  color: Colors.black87,
                                ),
                                SizedBox(height: 6),
                                Text('Subs', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 84,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.grid_view_rounded,
                                  size: 26,
                                  color: Colors.black87,
                                ),
                                SizedBox(height: 6),
                                Text('Lainnya', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.local_activity_outlined,
                            size: 20,
                            color: Colors.teal,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Redeem Voucher Prakerjamu',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Kamu pengguna Prakerja? Segera redeem vouchermu sekarang juga',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 46,
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade500),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onPressed: () {
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          },
                          child: const Text('Masukkan Voucher Prakerja'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ===== SECTION: Kelas Terpopuler di Prakerja =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: const Text(
                  'Kelas Terpopuler di Prakerja',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),

              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // ---- Card 1 ----
                    Container(
                      width: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner / thumbnail
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.asset(
                              'lib/assets/images/judul_kelas_1.png',
                              height: 90,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Isi kartu
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // chips/tag
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEEF5FF),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'LuarSekolah',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF1976D2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    // Container(
                                    //   padding: const EdgeInsets.symmetric(
                                    //     horizontal: 8,
                                    //     vertical: 4,
                                    //   ),
                                    //   decoration: BoxDecoration(
                                    //     color: const Color(0xFFEFF7F2),
                                    //     borderRadius: BorderRadius.circular(8),
                                    //   ),
                                    //   child: const Text(
                                    //     'SPL',
                                    //     style: TextStyle(
                                    //       fontSize: 11,
                                    //       color: Color(0xFF2E7D32),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Judul
                                const Text(
                                  'Judul kelas ke-1',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 8),

                                // rating
                                Row(
                                  children: const [
                                    Text(
                                      '4.5 ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFFFFB300),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFFFFB300),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFFFFB300),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFFFFB300),
                                    ),
                                    Icon(
                                      Icons.star_half,
                                      size: 16,
                                      color: Color(0xFFFFB300),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // harga
                                const Text(
                                  'Rp 1.500.000',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // ---- Card 2 ----
                    Container(
                      width: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.asset(
                              'lib/assets/images/judul_kelas_2.png',
                              height: 90,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // chips/tag
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEEF5FF),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'LuarSekolah',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF1976D2),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    // (opsional) chip kedua :
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF7F2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'SPL',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF2E7D32),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // judul
                                const Text(
                                  'Judul kelas ke-2',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 8),

                                // rating
                                Row(
                                  children: const [
                                    Text(
                                      '4.5 ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFFFFB300),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFFFFB300),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFFFFB300),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Color(0xFFFFB300),
                                    ),
                                    Icon(
                                      Icons.star_half,
                                      size: 16,
                                      color: Color(0xFFFFB300),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // harga
                                const Text(
                                  'Rp 900.000',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // link "Lihat Semua Kelas"
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Lihat Semua Kelas',
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              // ===== SECTION: Akses Semua Kelas dengan Berlangganan =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: const Text(
                  'Akses Semua Kelas dengan Berlangganan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),

              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // ---- Card 1 ----
                    Container(
                      width: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.asset(
                              'lib/assets/images/judul_kelas_3.png',
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.menu_book_outlined,
                                      size: 16,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '5 Kelas Pembelajaran',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Belajar Judul Kelas ke - 1',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // ---- Card 2 ----
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.asset(
                              'lib/assets/images/judul_kelas_4.png',
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.menu_book_outlined,
                                      size: 16,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '7 Kelas Pembelajaran',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Belajar judul kelas  ke - 2',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // ---- Card 3  ----
                  ],
                ),
              ),

              // link "Lihat Semua"
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  height: 46,
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Kembali'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
