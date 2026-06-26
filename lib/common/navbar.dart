import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';

class Navbar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const Navbar({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Beranda",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          label: "Order",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: "Favorit",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profil",
        ),
      ],
      currentIndex: index,
      backgroundColor: Colors.white,
      selectedItemColor: Warna.warnaAccent,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 11.0,
      unselectedFontSize: 11.0,
      showUnselectedLabels: true,
      onTap: onTap,
    );
  }
}