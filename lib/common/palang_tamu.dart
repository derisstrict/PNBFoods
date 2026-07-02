import 'package:flutter/material.dart';
import 'package:pnbfoods/auth/login_page.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PalangTamu extends StatelessWidget {
  final String text;

  const PalangTamu({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Belum Login",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            Text(text, textAlign: TextAlign.center,),
            SizedBox(
              height: 40,
              width: 150,
              child: TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(role: 'pelanggan')));
                  },
                  style: TextButton.styleFrom(
                    
                    backgroundColor: Warna.warnaAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10)
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Icon(Icons.login),
                      Text("Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ) 
                ),
            )
          ],
        ),
      ),
    );
  }
}