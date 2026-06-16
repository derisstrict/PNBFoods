import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/produk.dart';
import 'package:pnbfoods/pembeli/list_produk/widget/card_produk.dart';
import 'package:pnbfoods/penjual/dashboard/widgets/text_heading.dart';
import 'package:pnbfoods/penjual/form_produk/form_produk.dart';
import 'package:pnbfoods/services/produk_service.dart';

class Dashboard extends StatefulWidget {
  State<Dashboard> createState() => _DashboardState();
} 

class _DashboardState extends State<Dashboard> {

  late Future<List<Produk>> _futureProduk;
  String? _appDirPath;


 Future<void> _initPath() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    setState(() {
      _appDirPath = appDir.path;
    });
  }

  @override
  void initState() {
    _futureProduk = fetchSemuaProduk();
    super.initState();
    _initPath();
  }

  void refreshProduk() {
    setState(() {
      _futureProduk = fetchSemuaProduk();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenPadding = 50.0;
            double finalWidth = (screenWidth - (screenPadding * 2)) / 2;
            return SingleChildScrollView(
              child: Column(
                children: [
                  TopBarHeader(
                    width: screenWidth, 
                    style: TopBarHeader.penjual, 
                    text1: "Halo,",
                    text2: "Bu Wati",
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      spacing: 12.0,
                      children: [
                        TextHeading(title: "Kantin Anda"),
                        IntrinsicHeight(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.image_not_supported_outlined,
                                  size: 90,
                                  color: Warna.warnaTextGray,
                                ),
                                Column(
                                  spacing: 4.0,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Kantin Ibu Gacor",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14
                                      ),
                                    ),
                                    Text("Makanan & Minuman",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(12, 3, 12, 3),
                                      decoration: BoxDecoration(
                                        color: Warna.warnaBackground,
                                        borderRadius: BorderRadius.circular(25)
                                      ),
                                      child: Text(
                                        "Rp. 5rb-35rb",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(Icons.edit,
                                      color: Warna.warnaAccent,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10,)
                              ],
                            ),
                          ),
                        ),
                        TextHeading(title: "Pendapatan"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Icon(Icons.account_balance_wallet_rounded)
                                    ],
                                  ),
                                  SizedBox(width: 5,),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                        children: [
                                          Text("Total pendapatan hari ini",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Spacer(),
                                          Text("Total",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                        Row(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Rp.",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Warna.warnaAccent
                                                  ),
                                                ),
                                                SizedBox(width: 4.0,),
                                                Text("134.000",
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Warna.warnaAccent
                                                  ),
                                                )
                                              ],
                                            ),
                                            Spacer(),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Rp.",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Warna.warnaAccent
                                                  ),
                                                ),
                                                SizedBox(width: 4.0,),
                                                Text("134.000",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Warna.warnaAccent
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: screenWidth - 80,
                              padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
                              decoration: BoxDecoration(
                                color: Warna.warnaAccent,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)
                                )
                              ),
                              child: Row(
                                children: [
                                  Text("8 produk terjual hari ini",
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.white
                                    ),
                                  ),
                                  Spacer(),
                                  Text("8 produk total terjual",
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            TextHeading(title: "Pesanan"),
                            Spacer(),
                            Text("2 pesanan",
                              style: TextStyle(
                                fontSize: 12,
                                color: Warna.warnaAccent
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: Column(
                            spacing: 10.0,
                            children: [
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
                                    Text("johndoe@gmail.com",
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
                                        Text("Rp. 68.000", 
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
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.white
                                ),
                                child: Center(
                                  child: Text("Lihat selengkapnya",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextHeading(title: "Menu"),
                        TombolLebar(
                          function: () async {
                            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => FormProduk()));
                            setState(() {
                              if (result == true) {
                                refreshProduk();
                              }
                            });
                          }, 
                          backgroundColor: Warna.warnaAccent, 
                          foregroundColor: Colors.white, 
                          text: "Tambah Menu",
                          icon: Icons.add,
                        ),
                        FutureBuilder(
                          future: _futureProduk, 
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final items = snapshot.data!;
                              return MasonryGridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return CardProduk(
                                    produk: items[index], 
                                    appDir: _appDirPath!, 
                                    width: finalWidth,
                                    isEditable: true,
                                    onTap: () async {
                                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => FormProduk(produk: items[index],)));
                                      if (result == true) {
                                        refreshProduk();
                                      }
                                      
                                    },
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                            return const CircularProgressIndicator();
                          }
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        ) 
      ),
    );
  }
}