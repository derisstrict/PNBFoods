import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/item_keranjang.dart';

class RincianPesanan extends StatelessWidget {
  final List<ItemKeranjang> keranjang;
  final int totalHarga;
  final String Function(int) formatRupiah;

  const RincianPesanan({
    super.key,
    required this.keranjang,
    required this.totalHarga,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pesanan',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 10),
          ...keranjang.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item.jumlah}x ${item.nama}',
                        style: const TextStyle(fontSize: 13)),
                    Text(formatRupiah(item.subtotal),
                        style: const TextStyle(fontSize: 13)),
                  ],
                ),
              )),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                formatRupiah(totalHarga),
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Warna.warnaAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}