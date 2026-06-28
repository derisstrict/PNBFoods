import 'package:flutter/material.dart';
import 'package:pnbfoods/models/item_riwayat.dart';

class DetailBelanja extends StatelessWidget {
  final List<ItemRiwayat> items;
  final String Function(int) formatRupiah;

  const DetailBelanja({
    super.key,
    required this.items,
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
            'Detail Belanja',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.jumlah}x ${item.nama}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      formatRupiah(item.subtotal),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}