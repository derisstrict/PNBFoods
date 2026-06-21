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
      padding: const EdgeInsets.all(20),
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
            child: Image.network(
              transaksi.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (contex, a, b) => Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.store, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 12),

          //?Info kantin
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //?nama kantin
                Text(
                  transaksi.namaKantin,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                //?kategori kantin
                Text(
                  transaksi.kategoriKantin,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 25),
                //?jumlah item produk yang dibeli
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