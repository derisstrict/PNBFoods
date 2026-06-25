import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/item_keranjang.dart';

class CardItemKeranjang extends StatelessWidget {
  final ItemKeranjang item;
  final String Function(int) formatRupiah;
  final VoidCallback onTambah;
  final VoidCallback onKurang;

  const CardItemKeranjang({
    super.key,
    required this.item,
    required this.formatRupiah,
    required this.onTambah,
    required this.onKurang,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          //*Foto produk
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, a, b) => Container(
                width: 70,
                height: 70,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 12),

          //*Info produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formatRupiah(item.harga),
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 5),
                Text(
                  'x${item.jumlah}  ${formatRupiah(item.subtotal)}',
                  style: TextStyle(
                    color: Warna.warnaAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          //*Tombol +/-
          Row(
            children: [
              GestureDetector(
                onTap: onKurang,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.remove, size: 18),
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Warna.warnaAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${item.jumlah}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onTambah,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.add, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}