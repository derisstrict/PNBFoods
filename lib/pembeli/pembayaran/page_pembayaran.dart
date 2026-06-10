import 'package:flutter/material.dart';
import 'package:pnbfoods/models/item_keranjang.dart';
import 'package:pnbfoods/pembeli/pembayaran/widget/countdown_kadaluwarsa.dart';
import 'package:pnbfoods/pembeli/pembayaran/widget/qris_box.dart';
import 'package:pnbfoods/pembeli/pembayaran/widget/tombol_pembayaran.dart';
import 'package:pnbfoods/services/cart_service.dart';

class PembayaranPage extends StatefulWidget {
  final int totalHarga;
  final List<ItemKeranjang> items;

  const PembayaranPage({
    super.key,
    required this.totalHarga,
    required this.items,
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final Color warnaOrange = const Color(0xFFF9803B);
  int sisaDetik = 86400;

  String get formatWaktu {
    final jam = (sisaDetik ~/ 3600).toString().padLeft(2, '0');
    final menit = ((sisaDetik % 3600) ~/ 60).toString().padLeft(2, '0');
    final detik = (sisaDetik % 60).toString().padLeft(2, '0');
    return '$jam:$menit:$detik';
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
            title: const Text(
              'Pembayaran',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menunggu pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              formatRupiah(widget.totalHarga),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            CountdownKadaluwarsa(formatWaktu: formatWaktu),
            const SizedBox(height: 20),

            QrisBox(
              totalHarga: widget.totalHarga,
              warnaOrange: warnaOrange,
              onSimpanQr: () {},
            ),
            const SizedBox(height: 16),

            TombolPembayaran(
              onKembali: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  CartService().clear();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Selesaikan Pembayaran",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
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