import 'package:flutter/material.dart';
import 'package:pnbfoods/models/item_riwayat.dart';
import 'package:pnbfoods/pembeli/riwayat/widget/card_transaksi.dart';
import 'package:pnbfoods/pembeli/riwayat/widget/detail_belanja.dart';

class SectionTanggal extends StatelessWidget {
  final RiwayatPerTanggal riwayat;
  final String Function(int) formatRupiah;
  final Color warnaOrange;

  const SectionTanggal({
    super.key,
    required this.riwayat,
    required this.formatRupiah,
    required this.warnaOrange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //*Header tanggal + total harga
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //?tanggal di sebelah kiri
            Text(
              riwayat.tanggal,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            //?total harga di sebelah kanan
            Text(
              formatRupiah(
                riwayat.transaksi.fold(0, (sum, t) => sum + t.totalHarga),
              ),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 10),

        //*List transaksi di tanggal ini
        ...riwayat.transaksi.map((transaksi) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //?jam dibawah header tanggal
                Text(
                  transaksi.jam,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(height: 8),
                //?memanggil card transaksi
                CardTransaksi(
                  transaksi: transaksi,
                  formatRupiah: formatRupiah,
                  warnaOrange: warnaOrange,
                ),
                const SizedBox(height: 10),
                //?memanggi detailbelanja
                DetailBelanja(
                  items: transaksi.items,
                  formatRupiah: formatRupiah,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}