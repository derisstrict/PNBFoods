import 'package:flutter/material.dart';
import 'package:pnbfoods/database/database.dart';
import 'package:pnbfoods/pembeli/list_produk/list_produk.dart';
import 'package:pnbfoods/penjual/form_produk/form_produk.dart';

late AppDatabase database;
void main() {
  database = AppDatabase();
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
      home: ListProduk(),
    );
  }
}