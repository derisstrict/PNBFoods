import 'package:flutter/material.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/homepage/home.dart';
import 'package:pnbfoods/models/item_keranjang.dart';
import 'package:pnbfoods/models/kantin.dart';
import 'package:pnbfoods/pembeli/keranjang/widget/card_item_keranjang.dart';
import 'package:pnbfoods/pembeli/keranjang/widget/metode_pembayaran.dart';
import 'package:pnbfoods/pembeli/keranjang/widget/pengambilan_kantin.dart';
import 'package:pnbfoods/pembeli/keranjang/widget/rincian_pesanan.dart';
import 'package:pnbfoods/pembeli/pembayaran/page_pembayaran.dart';
import 'package:pnbfoods/services/cart_service.dart';

class KeranjangPage extends StatefulWidget {
  final Kantin kantin;

  const KeranjangPage({super.key, required this.kantin});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  List<ItemKeranjang> get keranjang => CartService().getAllItems(kantinId: widget.kantin.id);

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
    final item = keranjang[index];
    final id = item.produkId ?? item.nama.hashCode;
    CartService().addOrUpdate(widget.kantin.id, id, item.nama, item.harga, item.imageUrl, item.jumlah + 1);
    setState(() {});
  }

  void kurang(int index) {
    final item = keranjang[index];
    final id = item.produkId ?? item.nama.hashCode;
    if (item.jumlah <= 1) {
      CartService().removeItem(widget.kantin.id, id);
    } else {
      CartService().addOrUpdate(widget.kantin.id, id, item.nama, item.harga, item.imageUrl, item.jumlah - 1);
    }
    if (CartService().isEmpty(kantinId: widget.kantin.id)) {
      Navigator.pop(context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = keranjang;
    final kantin = widget.kantin;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: TopBar(title: "Keranjang", icon: Icons.shopping_cart_outlined,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${items.length} Item',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...List.generate(items.length, (index) {
              return CardItemKeranjang(
                item: items[index],
                formatRupiah: formatRupiah,
                onTambah: () => tambah(index),
                onKurang: () => kurang(index),
              );
            }),

            const SizedBox(height: 8),
            PengambilanKantin(
              namaKantin: widget.kantin.namaKantin,
              fotoUrl: widget.kantin.fotoUrl,
            ),
            const SizedBox(height: 10),
            const MetodePembayaran(),
            const SizedBox(height: 10),

            RincianPesanan(
              keranjang: items,
              totalHarga: totalHarga,
              formatRupiah: formatRupiah,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PembayaranPage(
                        totalHarga: totalHarga,
                        items: items,
                        kantinId: widget.kantin.id,
                      ),
                    ),
                  );
                  if (result == true) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePengguna()), (route) => false);
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Warna.warnaAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pesan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
