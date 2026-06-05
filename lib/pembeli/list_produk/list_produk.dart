import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
// import 'package:pnbfoods/database/database.dart';
import 'package:pnbfoods/main.dart';
import 'package:pnbfoods/models/produk.dart';
import 'package:pnbfoods/pembeli/list_produk/widget/card_menu.dart';
import 'package:pnbfoods/penjual/form_produk/form_produk.dart';
import 'package:pnbfoods/services/produk_service.dart';

class ListProduk extends StatefulWidget {
  @override 
  _ListProdukState createState() => _ListProdukState();
}

class _ListProdukState extends State<ListProduk> {
  int _selectedNavbar = 0;

  String? _appDirPath;

  String? _filterMakanan = "";

  late Future<List<Produk>> futureProduk;

  void _changeSelectedNavbar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  Future<void> _initPath() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    setState(() {
      _appDirPath = appDir.path;
    });
  }
  
  @override
  void initState() {
    super.initState();
    futureProduk = fetchSemuaProduk();
    _initPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBarless(),
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenPadding = 40.0;
            double finalWidth = (screenWidth - (screenPadding * 2)) / 2;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9803B),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(15),
                                child: FlutterLogo(),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Kantin Ibu Gacor",
                                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16.0),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Makanan & Minuman",
                                    style: TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 12.0),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Container(
                            padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search_outlined, color: Color(0xFFF9803B),),
                                SizedBox(width: 5,),
                                Text("Nasi Goreng",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black38
                                ),),
                                Spacer(),
                                Text("cari di kantin ini", 
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFFF9803B)
                                  ),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text("Apa yang ingin kamu cari?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _filterMakanan = "";
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: _filterMakanan == "" ? Warna.warnaAccent :Colors.white,
                                foregroundColor: _filterMakanan == "" ? Colors.white :Colors.black
                              ),
                              child: Text("Semua",)
                            ),
                            SizedBox(width: 10,),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _filterMakanan = "Makanan";
                                });
                              }, 
                              style: TextButton.styleFrom(
                                backgroundColor: _filterMakanan == "Makanan" ? Warna.warnaAccent :Colors.white,
                                foregroundColor: _filterMakanan == "Makanan" ? Colors.white :Colors.black
                              ), 
                              child: Text("Makanan",)
                            ),
                            SizedBox(width: 10,),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _filterMakanan = "Minuman";
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: _filterMakanan == "Minuman" ? Warna.warnaAccent :Colors.white,
                                foregroundColor: _filterMakanan == "Minuman" ? Colors.white :Colors.black
                              ), 
                              child: Text("Minuman")
                            ),
                          ],
                        ),
                        FutureBuilder<List<Produk>>(
                          future: futureProduk, 
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final items = snapshot.data!;

                              final filterItems = items.where((produk) {
                                if (_filterMakanan == "") return true;
                                return produk.kategoriProduk == _filterMakanan;
                              }).toList();

                              return MasonryGridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                itemCount: filterItems.length,
                                itemBuilder: (context, index) {
                                    return CardProduk(produk: filterItems[index], appDir: _appDirPath!, width: finalWidth,);
                                }
                              );
                            } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                            return const CircularProgressIndicator();
                          }
                        ),
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TombolNavigasi(
                              function: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => FormProduk()));
                                setState(() {
                                  futureProduk = fetchSemuaProduk();
                                });
                              }, 
                              backgroundColor: Colors.white, 
                              foregroundColor: Colors.black, 
                              text: "Buat Produk"
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
            );
          }
        ) 
      ), 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Beranda"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: "Order"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Favorit"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil"
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
