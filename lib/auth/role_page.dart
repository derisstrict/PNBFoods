import 'package:flutter/material.dart';
import 'package:pnbfoods/auth/login_page.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/warna.dart';

class PilihRole extends StatelessWidget {
  
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TombolNavigasi(
            function: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage(role: 'pelanggan'))), 
            backgroundColor: Warna.warnaAccent, 
            foregroundColor: Colors.white, 
            text: "Pelanggan",
          ),
          SizedBox(height: 10),
          TombolNavigasi(
            function: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage(role: 'penjual'))), 
            backgroundColor: Warna.warnaAccent, 
            foregroundColor: Colors.white, 
            text: "Penjual",
          )
        ],
      )),
    );
   }
}