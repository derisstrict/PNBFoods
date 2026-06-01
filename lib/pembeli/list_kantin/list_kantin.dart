import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/warna.dart';
// import 'package:pnbfoods/database/database.dart';
import 'package:pnbfoods/main.dart';
import 'package:pnbfoods/models/produk.dart';
import 'package:pnbfoods/pembeli/list_kantin/widget/card_kantin.dart';
import 'package:pnbfoods/pembeli/list_produk/widget/card_menu.dart';
import 'package:pnbfoods/penjual/form_produk/form_produk.dart';
import 'package:pnbfoods/services/produk_service.dart';
import 'package:pnbfoods/pembeli/list_kantin/widget/banner_kantin.dart';

class ListKantin extends StatefulWidget {
  @override
  _ListKantinState createState() => _ListKantinState();
}

class _ListKantinState extends State<ListKantin> {
  final List<Map<String, String>> daftarKantin = [
    {
      "nama": "Kantin Ibu Gacor",
      "kategori": "Makanan & Minuman",
      "harga": "400+ terjual | Rp. 5rb-35rb",
      "gambar": "https://picsum.photos/200?1",
    },
    {
      "nama": "Kantin Robert",
      "kategori": "Cemilan",
      "harga": "1RB+ terjual | Rp. 5rb-20rb",
      "gambar": "https://picsum.photos/200?2",
    },
    {
      "nama": "Kantin Pojok Situ",
      "kategori": "Aneka Nasi",
      "harga": "897+ terjual | Rp. 10rb-50rb",
      "gambar": "https://picsum.photos/200?3",
    },
    {
      "nama": "Kantin Bu Joko",
      "kategori": "Makanan & Minuman",
      "harga": "500+ terjual | Rp. 8rb-30rb",
      "gambar": "https://picsum.photos/200?4",
    },
  ];

  int _selectedNavbar = 0;

  String? _appDirPath;

  late Future<List<Produk>> futureProduk;

  void _changeSelectedNavbar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  // Future<void> _initPath() async {
  //   final Directory appDir = await getApplicationDocumentsDirectory();
  //   setState(() {
  //     _appDirPath = appDir.path;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   futureProduk = fetchSemuaProduk();
  //   _initPath();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFFF9803B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello",
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Ngab Owi",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          Spacer(),

                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              'https://i.pravatar.cc/150',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.only(
                        top: 5,
                        left: 10,
                        right: 10,
                        bottom: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search_outlined, color: Color(0xFFF9803B)),
                          SizedBox(width: 5),
                          Text(
                            "Kantin Ibu Gacor",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black38,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.restaurant,
                            color: Warna.warnaAccent,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BannerPromo(imageUrl: "https://picsum.photos/800/400"),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFF9803B),
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Semua"),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: Text("Terlaris"),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: Text("Termurah"),
                      ),
                    ],
                  ),
                  // FutureBuilder<List<Produk>>(
                  //   future: futureProduk,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return MasonryGridView.builder(
                  //         shrinkWrap: true,
                  //         physics: NeverScrollableScrollPhysics(),
                  //         gridDelegate:
                  //             SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  //               crossAxisCount: 2,
                  //             ),
                  //         itemCount: snapshot.data!.length,
                  //         itemBuilder: (context, index) {
                  //           return CardProduk(
                  //             produk: snapshot.data![index],
                  //             appDir: _appDirPath!,
                  //           );
                  //         },
                  //       );
                  //     } else if (snapshot.hasError) {
                  //       return Text('${snapshot.error}');
                  //     }
                  //     return const CircularProgressIndicator();
                  //   },
                  // ),
                  SizedBox(height: 25),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: daftarKantin.length,
                    itemBuilder: (context, index) {
                      final kantin = daftarKantin[index];

                      return CardKantin(
                        namaKantin: kantin["nama"]!,
                        kategori: kantin["kategori"]!,
                        infoHarga: kantin["harga"]!,
                        imageUrl: kantin["gambar"]!,
                      );
                    },
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     TombolNavigasi(
                  //       function: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => FormProduk(),
                  //           ),
                  //         );
                  //       },
                  //       backgroundColor: Colors.white,
                  //       foregroundColor: Colors.black,
                  //       text: "Buat Produk",
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Favorit",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
        currentIndex: _selectedNavbar,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFF9803B),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11.0,
        unselectedFontSize: 11.0,
        showUnselectedLabels: true,
        onTap: _changeSelectedNavbar,
      ),
    );
  }
}
