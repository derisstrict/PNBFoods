import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/produk.dart';

class CardProduk extends StatelessWidget {
  final Produk produk;
  final String appDir;
  final bool isAccent;
  final int cartCount;
  final double width;
  final bool isEditable;
  final GestureTapCallback onTap;

  const CardProduk({super.key, required this.produk, required this.appDir, required this.width, this.isAccent = false, this.cartCount = 0, this.isEditable = false, required this.onTap});

  String formatRupiah(int nilai) {
    final formatted = nilai.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp. $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isAccent ? Warna.warnaAccent : Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: Container(
                        child: produk.fotoProduk == "" || produk.fotoProduk == null 
                        ? 
                        Icon(Icons.image_rounded, size: 100, color: Warna.warnaBackground,) 
                        : 
                        Image.network(produk.fotoUrl!, fit: BoxFit.cover, width: width, height: 220, cacheHeight: 400,),
                      ) 
                    )
                  ],
                ),
                SizedBox(height: 5,),
                Text(produk.namaProduk,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isAccent ? Colors.white : Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Text(formatRupiah(produk.hargaProduk),
                      style: TextStyle(
                        color: isAccent ? Colors.white : Warna.warnaAccent,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Spacer(),
                    Visibility(
                      visible: isAccent,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10, top: 1, right: 10, bottom: 1),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: Text("$cartCount", 
                            style: TextStyle(
                              fontSize: 12,
                              color: Warna.warnaAccent
                            ),),
                          )
                        ],
                      )
                    ),
                    Visibility(
                      visible: isEditable,
                      child: Icon(Icons.edit,
                        size: 18.0,
                        color: Warna.warnaAccent,
                      )
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
    
  }
}
