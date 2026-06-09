import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnbfoods/common/navbar.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/warna.dart';
// import 'package:pnbfoods/database/database.dart';
import 'package:pnbfoods/main.dart';
import 'package:pnbfoods/models/produk.dart';
import 'package:pnbfoods/models/kantin.dart';
import 'package:pnbfoods/pembeli/list_kantin/widget/card_kantin.dart';
import 'package:pnbfoods/pembeli/list_produk/widget/card_menu.dart';
import 'package:pnbfoods/penjual/form_produk/form_produk.dart';
import 'package:pnbfoods/penjual/form_kantin/form_kantin.dart';
import 'package:pnbfoods/services/produk_service.dart';
import 'package:pnbfoods/services/kantin_service.dart';
import 'package:pnbfoods/pembeli/list_kantin/widget/banner_kantin.dart';

class ListKantin extends StatefulWidget {
  @override
  _ListKantinState createState() => _ListKantinState();
}

class _ListKantinState extends State<ListKantin> {
  late Future<List<Kantin>> futureKantin;
  int _selectedNavbar = 0;

  @override
  void initState() {
    super.initState();
    futureKantin = fetchSemuaKantin();
  }

  void refreshKantin() {
    setState(() {
      futureKantin = fetchSemuaKantin();
    });
  }

  void _changeSelectedNavbar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  Future<void> _hapusKantin(Kantin kantin) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Kantin"),
        content: Text("Apakah Anda yakin ingin menghapus ${kantin.namaKantin}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await deleteKantin(kantin.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${kantin.namaKantin} berhasil dihapus")),
          );
          refreshKantin();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal menghapus kantin: $e")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xFFF9803B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello",
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Ngab Owi",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        Spacer(),

                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                      right: 10,
                      bottom: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search_outlined, color: Color(0xFFF9803B)),
                        SizedBox(width: 5),
                        Text(
                          "Kantin Ibu Gacor",
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                        Spacer(),
                        Icon(
                          Icons.restaurant,
                          color: Warna.warnaAccent,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 5),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFF9803B),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Semua"),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: Text("Terlaris"),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: Text("Termurah"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: FutureBuilder<List<Kantin>>(
              future: futureKantin,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada kantin.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final kantin = snapshot.data![index];

                      return CardKantin(
                        namaKantin: kantin.namaKantin,
                        kategori: kantin.kategori,
                        infoHarga: "Lihat Menu",
                        imageUrl: kantin.fotoUrl ?? 'https://picsum.photos/200?id=${kantin.id}',
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormKantin(kantin: kantin),
                            ),
                          );
                          if (result == true) {
                            refreshKantin();
                          }
                        },
                        onLongPress: () => _hapusKantin(kantin),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF9803B)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormKantin(),
            ),
          );
          if (result == true) {
            refreshKantin();
          }
        },
        backgroundColor: const Color(0xFFF9803B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
