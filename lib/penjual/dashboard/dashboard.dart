import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/penjual.dart';
import 'package:pnbfoods/models/produk.dart';
import 'package:pnbfoods/pembeli/list_produk/widget/card_produk.dart';
import 'package:pnbfoods/penjual/dashboard/widgets/text_heading.dart';
import 'package:pnbfoods/penjual/form_produk/form_produk.dart';
import 'package:pnbfoods/penjual/form_kantin/form_kantin.dart';
import 'package:pnbfoods/services/penjual_service.dart';
import 'package:pnbfoods/services/produk_service.dart';
import 'package:pnbfoods/models/kantin.dart';
import 'package:pnbfoods/services/kantin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<Kantin?> _futureKantin;
  late Future<List<Produk>> _futureProduk;
  String penjual = "";
  String? _appDirPath;

  Future<void> _initPath() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    setState(() {
      _appDirPath = appDir.path;
    });
  }

  Future<Kantin?> _loadKantin() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return null;
    try {
      return await fetchKantinByPenjual(userId);
    } catch (e) {
      return null;
    }
  }

  void _ambilNamaPenjual() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    fetchPenjual(userId!).then((Penjual hasil) {
      setState(() {
        penjual = hasil.namaPenjual;
      });
    });
  }

  void _ambilProdukPenjual() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    _futureProduk = fetchProdukByPenjual(userId!);
  }

  @override
  void initState() {
    super.initState();
    _futureKantin = _loadKantin();
    _ambilProdukPenjual();
    _ambilNamaPenjual();
    _initPath();
  }

  void refreshDashboard() {
    setState(() {
      _futureKantin = _loadKantin();
    });
  }

  void refreshProduk() {
    setState(() {
      _futureProduk = fetchSemuaProduk();
    });
  }

  Widget _buildKantinImage(Kantin kantinData) {
    if (kantinData.fotoUrl != null && kantinData.fotoUrl!.isNotEmpty) {
      return Image.network(
        kantinData.fotoUrl!,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.image_not_supported_outlined,
            size: 90,
            color: Warna.warnaTextGray,
          );
        },
      );
    }

    if (kantinData.fotoKantin == null ||
        kantinData.fotoKantin!.isEmpty ||
        _appDirPath == null) {
      return Icon(
        Icons.image_not_supported_outlined,
        size: 90,
        color: Warna.warnaTextGray,
      );
    }

    final File file = File('$_appDirPath/${kantinData.fotoKantin}');
    return Image.file(
      file,
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.image_not_supported_outlined,
          size: 90,
          color: Warna.warnaTextGray,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenPadding = 50.0;
            double finalWidth = (screenWidth - (screenPadding * 2)) / 2;
            return SingleChildScrollView(
              child: Column(
                children: [
                  TopBarHeader(
                    width: screenWidth,
                    style: TopBarHeader.penjual,
                    text1: "Halo,",
                    text2: penjual,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: FutureBuilder<Kantin?>(
                      future: _futureKantin,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            _appDirPath == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final kantinData = snapshot.data;

                        if (kantinData == null) {
                          // UI "Dashboard Penjual Baru"
                          return Column(
                            spacing: 12.0,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextHeading(title: "Kantin Anda"),
                              TombolLebar(
                                function: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FormKantin(),
                                    ),
                                  );

                                  if (result != null) {
                                    refreshDashboard();
                                  }
                                },
                                backgroundColor: Warna.warnaAccent,
                                foregroundColor: Colors.white,
                                text: "Tambah Kantin Anda",
                                icon: Icons.add,
                              ),
                            ],
                          );
                        }

                        // UI "Dashboard Penjual Tanpa Menu"
                        return Column(
                          spacing: 12.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextHeading(title: "Kantin Anda"),
                            IntrinsicHeight(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _buildKantinImage(kantinData),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        spacing: 4.0,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            kantinData.namaKantin,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            kantinData.kategori,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                              12,
                                              3,
                                              12,
                                              3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Warna.warnaBackground,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Text(
                                              "Rp. 5rb-35rb",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FormKantin(
                                                      kantin: kantinData,
                                                    ),
                                              ),
                                            );
                                            if (result != null) {
                                              refreshDashboard();
                                            }
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Warna.warnaAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                            TextHeading(title: "Pendapatan"),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Icon(
                                            Icons
                                                .account_balance_wallet_rounded,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Total pendapatan hari ini",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "Total",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Rp.",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            Warna.warnaAccent,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4.0),
                                                    Text(
                                                      "0",
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Warna.warnaAccent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Rp.",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            Warna.warnaAccent,
                                                      ),
                                                    ),
                                                    SizedBox(width: 4.0),
                                                    Text(
                                                      "0",
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Warna.warnaAccent,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: screenWidth - 80,
                                  padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
                                  decoration: BoxDecoration(
                                    color: Warna.warnaAccent,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "0 produk terjual hari ini",
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w200,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "0 produk total terjual",
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w200,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TextHeading(title: "Pesanan"),
                                Spacer(),
                                Text(
                                  "0 pesanan",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Warna.warnaAccent,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Column(
                                spacing: 10.0,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Saat ini belum ada pesanan untuk ditampilkan",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextHeading(title: "Menu"),
                            TombolLebar(
                              function: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FormProduk(),
                                  ),
                                );
                                if (result == true) {
                                  setState(() {
                                    refreshProduk();
                                  });
                                }
                              },
                              backgroundColor: Warna.warnaAccent,
                              foregroundColor: Colors.white,
                              text: "Tambah Menu",
                              icon: Icons.add,
                            ),
                            FutureBuilder<List<Produk>>(
                              future: _futureProduk,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Belum ada Menu yang ditambahkan",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                if (snapshot.hasData) {
                                  final items = snapshot.data!;
                                  
                                  return MasonryGridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      return CardProduk(
                                        produk: items[index],
                                        appDir: _appDirPath!,
                                        width: finalWidth,
                                        isEditable: true,
                                        onTap: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FormProduk(
                                                produk: items[index],
                                              ),
                                            ),
                                          );
                                          if (result == true) {
                                            refreshProduk();
                                          }
                                        },
                                      );
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
