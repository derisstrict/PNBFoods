import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pnbfoods/auth/autentikasi.dart';
import 'package:pnbfoods/pembeli/list_kantin/list_kantin.dart';
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
