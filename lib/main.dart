import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pnbfoods/akun/akun_user.dart';
import 'package:pnbfoods/auth/autentikasi.dart';
import 'package:pnbfoods/pembeli/list_kantin/list_kantin.dart';
import 'package:pnbfoods/pembeli/list_produk/list_produk.dart';
import 'package:pnbfoods/pembeli/riwayat/page_riwayat.dart';
import 'package:pnbfoods/penjual/form_kantin/form_kantin.dart';
import 'package:pnbfoods/penjual/form_produk/form_produk.dart';
import '/pembeli/keranjang/page_keranjang.dart';
import 'package:pnbfoods/penjual/dashboard/dashboard.dart';
import 'package:pnbfoods/services/cart_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await CartService().init();
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
      home: Autentikasi(), // Defaultnya Autentikasi()
    );
  }
}
