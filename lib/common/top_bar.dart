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