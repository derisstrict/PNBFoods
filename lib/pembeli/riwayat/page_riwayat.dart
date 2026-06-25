import 'package:flutter/material.dart';
import 'package:pnbfoods/models/item_riwayat.dart';
import 'package:pnbfoods/services/riwayat_service.dart';
import 'package:pnbfoods/pembeli/riwayat/widget/section_tanggal.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final Color warnaOrange = const Color(0xFFF9803B);
  late Future<List<TransaksiRiwayat>> futureRiwayat;

  @override
  void initState() {
    super.initState();
    futureRiwayat = fetchRiwayat();
  }

  void refreshRiwayat() {
    setState(() {
      futureRiwayat = fetchRiwayat();
    });
  }

  String formatRupiah(int nilai) {
    final formatted = nilai.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp. $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: AppBar(
            backgroundColor: warnaOrange,
            foregroundColor: Colors.white,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.history, size: 20),
                SizedBox(width: 8),
                Text(
                  'Riwayat',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<TransaksiRiwayat>>(
        future: futureRiwayat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(warnaOrange),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat riwayat: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          final semuaTransaksi = snapshot.data ?? [];

          if (semuaTransaksi.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada riwayat transaksi.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final riwayatPerTanggal = kelompokkanRiwayatPerTanggal(semuaTransaksi);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List riwayat per tanggal
                ...riwayatPerTanggal.map((r) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SectionTanggal(
                      riwayat: r,
                      formatRupiah: formatRupiah,
                      warnaOrange: warnaOrange,
                    ),
                  );
                }),

                // Tombol Kembali
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        selectedItemColor: warnaOrange,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }
}