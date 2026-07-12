import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';

class CardKantin extends StatelessWidget {
  final String namaKantin;
  final String kategori;
  final String infoHarga;
  final String imageUrl;
  final int cartItemCount;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CardKantin({
    super.key,
    required this.namaKantin,
    required this.kategori,
    required this.infoHarga,
    required this.imageUrl,
    this.cartItemCount = 0,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      width: 82,
                      height: 82,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 82,
                        height: 82,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 30),
                      ),
                    )
                  : Image.file(
                      File(imageUrl),
                      width: 82,
                      height: 82,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 82,
                        height: 82,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 30),
                      ),
                    ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    namaKantin,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 5),
                  Row(
                    spacing: 5,
                    children: [
                      Icon(Icons.label_outline, size: 16, color: Warna.warnaTextGray,),
                      Text(
                        kategori,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Warna.warnaTextGray, fontSize: 12),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 9),
                  Row(
                    spacing: 5,
                    children: [
                      Icon(infoHarga != 'kosong' ? Icons.sell_outlined : Icons.info_outline, size: 16, color: infoHarga != 'kosong' ? Warna.warnaAccent : Warna.warnaTextGray,),
                      Text(
                        infoHarga != 'kosong' ? infoHarga : 'Belum terdapat produk',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: infoHarga != 'kosong' ? Warna.warnaAccent : Warna.warnaTextGray, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (cartItemCount > 0)
              Container(
                padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                decoration: BoxDecoration(
                  color: Warna.warnaAccent,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5,),
                    Text("$cartItemCount",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ],
                ),
              ),
            SizedBox(width: 10,)
          ],
        ),
      ),
    );
  }
}
