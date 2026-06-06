import 'package:flutter/material.dart';
import 'package:pnbfoods/models/item_keranjang.dart';
import 'package:pnbfoods/pembeli/keranjang/widget/card_item_keranjang.dart';
import 'package:pnbfoods/pembeli/keranjang/widget/metode_pembayaran.dart';
import 'package:pnbfoods/pembeli/keranjang/widget/pengambilan_kantin.dart';
import 'package:pnbfoods/pembeli/keranjang/widget/rincian_pesanan.dart';
import 'package:pnbfoods/pembeli/pembayaran/page_pembayaran.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final Color warnaOrange = const Color(0xFFF9803B);
  List<ItemKeranjang> keranjang = List.from(dummyKeranjang);

  int get totalItem => keranjang.fold(0, (sum, item) => sum + item.jumlah);
  int get totalHarga => keranjang.fold(0, (sum, item) => sum + item.subtotal);

  String formatRupiah(int nilai) {
    final formatted = nilai.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp. $formatted';
  }

  void tambah(int index) {
    setState(() => keranjang[index].jumlah++);
  }

  void kurang(int index) {
    setState(() {
      if (keranjang[index].jumlah > 1) keranjang[index].jumlah--;
    });
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
                Icon(Icons.shopping_cart_outlined, size: 20),
                SizedBox(width: 8),
                Text(
                  'Keranjang',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$totalItem Item',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...List.generate(keranjang.length, (index) {
              return CardItemKeranjang(
                item: keranjang[index],
                formatRupiah: formatRupiah,
                onTambah: () => tambah(index),
                onKurang: () => kurang(index),
                warnaOrange: warnaOrange,
              );
            }),

            const SizedBox(height: 8),
            const PengambilanKantin(),
            const SizedBox(height: 10),
            const MetodePembayaran(),
            const SizedBox(height: 10),

            RincianPesanan(
              keranjang: keranjang,
              totalHarga: totalHarga,
              formatRupiah: formatRupiah,
              warnaOrange: warnaOrange,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PembayaranPage(
                        totalHarga: totalHarga,
                        items: keranjang,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: warnaOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pesan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
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