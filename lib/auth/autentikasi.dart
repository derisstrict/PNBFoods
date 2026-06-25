import 'package:flutter/material.dart';
import 'package:pnbfoods/auth/login_page.dart';
import 'package:pnbfoods/auth/role_page.dart';
import 'package:pnbfoods/homepage/home.dart';
import 'package:pnbfoods/penjual/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Autentikasi extends StatelessWidget {
  late final String rolePengguna;

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    rolePengguna = prefs.getString('role')!;
    return prefs.containsKey('userId');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        if (snapshot.data == true) {
          if (rolePengguna != "penjual") {
            return HomePengguna(); 
          } else {
            return Dashboard();
          }
        } else {
          return PilihRole();
        }
      },
    );
  }
}