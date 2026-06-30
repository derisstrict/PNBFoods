import 'package:flutter/material.dart';
import 'package:pnbfoods/akun/akun_user.dart';
import 'package:pnbfoods/common/navbar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/pembeli/list_kantin/list_kantin.dart';
import 'package:pnbfoods/pembeli/order/page_order.dart';
import 'package:pnbfoods/pembeli/favorit/favorit_page.dart';

class HomePengguna extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePengguna> {
  int _selectedNavbar = 0;
  List<Widget> halaman = [
    ListKantin(),
    OrderPage(),
    FavoritPage(),
    ProfileUser(),
    // PilihRole()
  ];

  void _updateSelectedNavbar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(child: halaman[_selectedNavbar]),
      bottomNavigationBar: Navbar(
        index: _selectedNavbar,
        onTap: _updateSelectedNavbar,
      ),
    );
  }
}
