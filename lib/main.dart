import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pnbfoods/akun/akun_user.dart';
import 'package:pnbfoods/auth/autentikasi.dart';
import 'package:pnbfoods/pembeli/favorit/favorit_page.dart';
import 'package:pnbfoods/pembeli/list_kantin/list_kantin.dart';
import 'package:pnbfoods/pembeli/list_produk/list_produk.dart';
import 'package:pnbfoods/pembeli/riwayat/page_riwayat.dart';
import 'package:pnbfoods/penjual/form_kantin/form_kantin.dart';
import 'package:pnbfoods/penjual/form_produk/form_produk.dart';
import '/pembeli/keranjang/page_keranjang.dart';
import 'package:pnbfoods/penjual/dashboard/dashboard.dart';
import 'package:pnbfoods/services/base_url.dart';
import 'package:pnbfoods/services/cart_service.dart';
import 'package:pnbfoods/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await BaseUrl.init();
  await CartService().init();
  await NotificationService.init();
  runApp(const PNBFoods());
}

class PNBFoods extends StatefulWidget {
  const PNBFoods({super.key});

  @override
  State<PNBFoods> createState() => _PNBFoodsState();
}

class _PNBFoodsState extends State<PNBFoods> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    NotificationService.startPolling();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NotificationService.stopPolling();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      NotificationService.startPolling();
    } else if (state == AppLifecycleState.paused) {
      NotificationService.stopPolling();
    }
  }

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
