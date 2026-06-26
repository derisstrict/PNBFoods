import 'package:flutter/material.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/penjual/pesanan/widget/detail_pesanan.dart';

enum Status { selesai, diproses, menunggu }

class Pesanan extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      appBar: TopBar(title: "Pesanan"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Wrap(
                  runSpacing: 10,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Warna.warnaAccent,
                        foregroundColor: Colors.white
                      ),
                      child: Text("Semua",)
                    ),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: () {}, 
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black
                      ), 
                      child: Text("Menunggu",)
                    ),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black
                      ), 
                      child: Text("Diproses")
                    ),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black
                      ), 
                      child: Text("Selesai")
                    ),
                  ],
                ),
                DetailPesanan(status: Status.menunggu,),
                DetailPesanan(status: Status.diproses,),
                DetailPesanan(status: Status.selesai,),
              ],
            ),
          )
        ) 
      ),
    );
  }
} 