import 'package:flutter/material.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/warna.dart';

import '../pesanan.dart';

class DetailPesanan extends StatelessWidget {
  final Status status;

  const DetailPesanan({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      spacing: 10,
      children: [
        Row(
          children: [
            Text("12.38 PM - 2 menit yang lalu",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white
          ),
          child: Row(
            spacing: 10.0,
            children: [
              Icon(Icons.image_not_supported_outlined,
                color: Warna.warnaTextGray,
              ),
              Text("John Doe",
                style: TextStyle(
                  fontWeight: FontWeight.w600
                ),
              ),
              Spacer(),
              Text("2415354001",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: switch (status) {
              Status.diproses => Warna.warnaWarning,
              Status.selesai => Warna.warnaSuccess,
              Status.menunggu => Colors.purple
            }
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                Icon(
                  switch (status) {
                    Status.diproses => Icons.timelapse,
                    Status.selesai => Icons.done,
                    Status.menunggu => Icons.lock_clock
                  },
                  color: Colors.white,
                ),
                Text(
                  switch (status) {
                    Status.diproses => "Sedang diproses",
                    Status.selesai => "Selesai",
                    Status.menunggu => "Menunggu pesanan diambil"
                  },
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w200
                  ),
                )
              ],
            )
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white
          ),
          child: Column(
            spacing: 5.0,
            children: [
              Row(
                children: [
                  Text("Detail Belanja", 
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700
                    ),),
                  Spacer(),
                  Text("Rp. 68.000", 
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Warna.warnaAccent,
                      fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text("2x Nasi Goreng Spesial", 
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                    ),),
                  Spacer(),
                  Text("Rp. 50.000", 
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text("1x Tipat Cantok", 
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                    ),),
                  Spacer(),
                  Text("Rp. 18.000", 
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: status != Status.selesai,
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white
            ),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Aksi",
                style: TextStyle(
                  fontWeight: FontWeight.w700
                ),
                ),
                Row(
                  children: [
                    TombolNavigasi(
                      function: () {}, 
                      backgroundColor: Warna.warnaAccent, 
                      foregroundColor: Colors.white, 
                      text: switch (status) {
                        Status.diproses => "Pesanan selesai",
                        Status.selesai => "",
                        Status.menunggu => "Ambil pesanan"
                      },
                      icon: Icons.done,
                    ),
                    Spacer(),
                    TombolNavigasi(
                      function: () {}, 
                      backgroundColor: Colors.red[50]!, 
                      foregroundColor: Colors.red, 
                      text: switch (status) {
                      Status.diproses => "Batalkan",
                      Status.selesai => "",
                      Status.menunggu => "Tolak"
                    },
                      icon: Icons.close,
                    ),
                  ],
                )
              ],
            )
          ),
        )
      ],
    );
  }
}