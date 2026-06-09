import 'package:flutter/material.dart';
import 'package:pnbfoods/pembeli/list_kantin/list_kantin.dart';
import 'package:pnbfoods/auth/login_page.dart';
import 'package:pnbfoods/pembeli/list_produk/list_produk.dart';
import 'package:pnbfoods/penjual/form_kantin/form_kantin.dart';
import 'package:pnbfoods/penjual/form_produk/form_produk.dart';
import '/pembeli/keranjang/page_keranjang.dart';

void main() {
  runApp(const PNBFoods());
}

class PNBFoods extends StatelessWidget {
  const PNBFoods({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PNBFoods",
      theme: ThemeData(fontFamily: 'Poppins'),
      // home: LoginPage(),
      // home: FormProduk(),
      home: KeranjangPage(),
      // home: FormKantin(),
      // home: FormKantin(),
    );
  }
}
