import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;

  const TopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Warna.warnaAccent,
      foregroundColor: Colors.white,
      title: Text(title, 
        style: TextStyle(
          fontSize: 16
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TopBarless extends StatelessWidget implements PreferredSizeWidget{

  const TopBarless({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Warna.warnaAccent,
      foregroundColor: Colors.white,
      toolbarHeight: 10.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);
}

class TopBarHeader extends StatelessWidget {

  final double width;
  final String style;
  final String text1;
  final String text2;

  static const String pembeli = "Pembeli";
  static const String penjual = "Penjual";

  const TopBarHeader({super.key, required this.width, required this.style, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: width,
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
                Visibility(
                  visible: style == pembeli,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back,
                          color: Colors.white,
                        )
                      ),
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(15),
                        child: FlutterLogo(),
                      ),
                      SizedBox(width: 10,),
                    ],
                  )
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(text1,
                      style: TextStyle(fontWeight: style == "pembeli" ? FontWeight.w500 : FontWeight.w200, color: Colors.white, fontSize: style == "pembeli" ? 16.0 : 12.0),
                    ),
                    SizedBox(height: 5,),
                    Text(text2,
                      style: TextStyle(fontWeight: style == "pembeli" ? FontWeight.w200 : FontWeight.w500, color: Colors.white, fontSize: style == "pembeli" ? 12.0 : 16.0),
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
    );
  }
}