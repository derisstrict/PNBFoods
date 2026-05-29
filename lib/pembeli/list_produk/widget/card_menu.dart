import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/database/database.dart';

class CardProduk extends StatelessWidget {
  final ProdukData produk;

  const CardProduk({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    final warna = Warna();
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
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
                      color: Colors.orange,
                      padding: EdgeInsets.all(10),
                      child: FlutterLogo(size: 145.0,),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Text(produk.namaProduk,
              style: TextStyle(
                fontWeight: FontWeight.w700
              ),),
              Row(
                children: [
                  Text("Rp. ${produk.hargaProduk}",
                  style: TextStyle(
                    color: warna.warnaTextAccent,
                    fontWeight: FontWeight.w500
                  ),),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class CardProdukAccent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(10),
      width: 180,
      decoration: BoxDecoration(
        color: Color(0xFFF9803B),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: FlutterLogo(),
              ),
              SizedBox(height: 5,),
              Text("Nasi Goreng Spesial",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white
              ),),
              Row(
                children: [
                  Text("Rp. 25.000",
                    style: TextStyle(
                      color: Colors.white
                    ),),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 1, right: 10, bottom: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("2", 
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFF9803B)
                    ),),
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