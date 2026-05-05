import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pnbfoods/list_produk/list_menu.dart';

class ListProduk extends StatefulWidget {
  @override 
  _ListProdukState createState() => _ListProdukState();
}

class _ListProdukState extends State<ListProduk> {
  int _selectedNavbar = 0;

  void _changeSelectedNavbar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F5F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 500,
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
                          child: Image.file(File('lib/img.png'), width: 60,),
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
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFF9803B),
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
                        child: Text("Makanan",)
                      ),
                      SizedBox(width: 10,),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black
                        ), 
                        child: Text("Minuman")
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      ListMenuAccent(),
                      ListMenu(),
                      ListMenu(),
                      ListMenuAccent(),
                      ListMenu(),
                      ListMenu(),
                      ListMenu(),
                      ListMenu(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
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
