import 'package:flutter/material.dart';
import 'package:pnbfoods/models/item_riwayat.dart';

class CardTransaksi extends StatelessWidget {
  final TransaksiRiwayat transaksi;
  final String Function(int) formatRupiah;
  final Color warnaOrange;

  const CardTransaksi({
    super.key,
    required this.transaksi,
    required this.formatRupiah,
    required this.warnaOrange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //?Foto kantin
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: transaksi.imageUrl != null
                ? Image.network(
                    transaksi.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, a, b) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(Icons.store, size: 30),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: const Icon(Icons.store, size: 30),
                  ),
          ),
          const SizedBox(width: 12),

          //?Info kantin
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaksi.namaKantin,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaksi.kategoriKantin,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${transaksi.totalItem} item',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),

          //?Total harga
          Text(
            formatRupiah(transaksi.totalHarga),
            style: TextStyle(
              color: warnaOrange,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}