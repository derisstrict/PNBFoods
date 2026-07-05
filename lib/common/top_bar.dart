import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pnbfoods/akun/akun_user.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/homepage/home.dart';
import 'package:pnbfoods/models/kantin.dart';
import 'package:pnbfoods/models/penjual.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? icon;

  const TopBar({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    final pop = Navigator.canPop(context);

    return AppBar(
      backgroundColor: Warna.warnaAccent,
      foregroundColor: Colors.white,
      centerTitle: true,
      leading: pop ? IconButton(
        onPressed: () {
          Navigator.maybePop(context, true);
        },
        icon: Icon(Icons.arrow_back),
      ) : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Row(children: [Icon(icon, size: 20), SizedBox(width: 5)]),
          Text(title, style: TextStyle(fontSize: 16)),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TopBarless extends StatelessWidget implements PreferredSizeWidget {
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
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String? searchHint;
  final Kantin? kantin;

  static const String pembeli = "Pembeli";
  static const String penjual = "Penjual";

  const TopBarHeader({
    super.key,
    required this.width,
    required this.style,
    required this.text1,
    required this.text2,
    this.searchController,
    this.onSearchChanged,
    this.searchHint,
    this.kantin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: style == pembeli ? 134 : 140,
      decoration: BoxDecoration(
        color: Warna.warnaAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                if (style == pembeli)
                  Visibility(
                    visible: style == pembeli,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.white24,
                            child:
                                kantin == null ||
                                    kantin!.fotoUrl == null ||
                                    kantin!.fotoUrl!.isEmpty
                                ? const Icon(
                                    Icons.image_rounded,
                                    size: 24,
                                    color: Colors.white,
                                  )
                                : (kantin!.fotoUrl!.startsWith('http')
                                      ? Image.network(
                                          kantin!.fotoUrl!,
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.image_rounded,
                                                    size: 24,
                                                    color: Colors.white,
                                                  ),
                                        )
                                      : Image.file(
                                          File(kantin!.fotoUrl!),
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.image_rounded,
                                                    size: 24,
                                                    color: Colors.white,
                                                  ),
                                        )),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text1,
                      style: TextStyle(
                        fontWeight: style == "Pembeli"
                            ? FontWeight.w500
                            : FontWeight.w200,
                        color: Colors.white,
                        fontSize: style == "Pembeli" ? 16.0 : 12.0,
                      ),
                    ),
                    SizedBox(height: 5),
                    if (style == "Pembeli")
                      Text(
                        text2,
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),

                    if (style == "Penjual")
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileUser(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Text(
                                text2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                Spacer(),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                  label: Text("Daftar kantin", 
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                  icon: Icon(Icons.store_mall_directory_outlined,
                    color: Colors.white,
                  )
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_outlined, color: Warna.warnaAccent),
                  SizedBox(width: 5),
                  Expanded(
                    child: searchController != null
                        ? TextField(
                            controller: searchController,
                            onChanged: onSearchChanged,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            decoration: InputDecoration(
                              hintText: searchHint,
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.black38,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          )
                        : Text(
                            searchHint ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black38,
                            ),
                          ),
                  ),
                  Text(
                    "cari di kantin ini",
                    style: TextStyle(fontSize: 10, color: Warna.warnaAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopBarHeaderPenjual extends StatelessWidget {
  final Penjual penjual;
  final Function returnFunction;

  const TopBarHeaderPenjual({
    super.key,
    required this.penjual,
    required this.returnFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: Warna.warnaAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Text("PNBFoods",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18
                  ),
                ),
                SizedBox(width: 5,),
                Text("Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileUser(),
                      ),
                    ).then((v) {
                      returnFunction();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(2, 8, 12, 8),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        CircleAvatar(
                              radius: 12,
                              backgroundColor:Color(0xFFD8BED0),
                              backgroundImage: penjual.fotoProfile != null
                                ? NetworkImage(penjual.fotoUrl!)
                                : null,
                            
                              child: penjual.fotoProfile == null
                                ? Icon( Icons.person, size: 12, color: Colors.white)
                                : null
                            ),
                        SizedBox(width: 5,),
                        Text(
                          penjual.namaPenjual,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(width: 8,),
                        Icon(
                          Icons.keyboard_arrow_right_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
