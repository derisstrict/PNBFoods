import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/database/database.dart';

class CardProduk extends StatelessWidget {
  final ProdukData produk;
  final String appDir;
  final bool isAccent = false;

  const CardProduk({super.key, required this.produk, required this.appDir});

  @override
  Widget build(BuildContext context) {
    File fileGambar = File(p.join(appDir, produk.fotoProduk));
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      width: 180,
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
                    child: produk.fotoProduk == "" ? Icon(Icons.image_rounded, size: 160, color: Warna.warnaBackground,) : Image.file(fileGambar, height: 160, width: 160, fit: BoxFit.cover,),
                  ),
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
                  Text("Rp. ${produk.hargaProduk}",
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
                          child: Text("2", 
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFF9803B)
                          ),),
                        )
                      ],
                    )
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
