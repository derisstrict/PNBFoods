import 'package:flutter/material.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/item_keranjang.dart';
import 'package:pnbfoods/pembeli/pembayaran/widget/countdown_kadaluwarsa.dart';
import 'package:pnbfoods/pembeli/pembayaran/widget/qris_box.dart';
import 'package:pnbfoods/pembeli/pembayaran/widget/tombol_pembayaran.dart';
import 'package:pnbfoods/services/cart_service.dart';
import 'package:pnbfoods/services/detail_orderan_service.dart';
import 'package:pnbfoods/services/orderan_service.dart';
import 'package:pnbfoods/services/pembayaran_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PembayaranPage extends StatefulWidget {
  final int totalHarga;
  final List<ItemKeranjang> items;
  final int kantinId;

  const PembayaranPage({
    super.key,
    required this.totalHarga,
    required this.items,
    required this.kantinId,
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
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
      appBar: TopBar(title: "Pembayaran", icon: Icons.payment),
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
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            CountdownKadaluwarsa(formatWaktu: formatWaktu),
            const SizedBox(height: 20),

            QrisBox(
              totalHarga: widget.totalHarga,
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
              child: TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final pelangganId = prefs.getInt('userId');
                  if (pelangganId == null) return;

                  final orderan = await postOrderan(
                    statusOrderan: 'diproses',
                    totalHarga: widget.totalHarga.toDouble(),
                    tanggalOrderan: DateTime.now(),
                    pelangganId: pelangganId,
                  );

                  for (final item in widget.items) {
                    await postDetailOrderan(
                      orderanId: orderan.id,
                      produkId: item.produkId ?? 0,
                      jumlah: item.jumlah,
                      catatan: item.catatan,
                    );
                  }

                  await postPembayaran(
                    orderanId: orderan.id,
                    metodePembayaran: 'QRIS',
                    totalPembayaran: widget.totalHarga.toDouble(),
                    statusPembayaran: 'lunas',
                  );

                  CartService().clear(kantinId: widget.kantinId);
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Warna.warnaAccent,
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
    );
  }
}