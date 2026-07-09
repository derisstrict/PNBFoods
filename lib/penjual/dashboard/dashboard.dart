import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import 'package:pnbfoods/penjual/pendapatan/pendapatan.dart';
import 'package:pnbfoods/penjual/pesanan/pesanan.dart';
import 'package:pnbfoods/services/notifikasi_service.dart';
import 'package:pnbfoods/services/notification_service.dart';
import 'package:pnbfoods/services/penjual_service.dart';
import 'package:pnbfoods/services/produk_service.dart';
import 'package:pnbfoods/models/kantin.dart';
import 'package:pnbfoods/services/kantin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pnbfoods/services/orderan_service.dart';
import 'package:pnbfoods/models/orderan.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<Kantin?> _futureKantin;
  late Future<List<Produk>> _futureProduk;
  Penjual? penjual;
  final _pesananController = StreamController<List<Orderan>>.broadcast();
  bool _isFirstLoadPesanan = true;
  int _todayIncome = 0;
  int _totalIncome = 0;
  int _todayProductsSold = 0;
  int _totalProductsSold = 0;
  String? _appDirPath;
  Timer? _refreshTimer;
  int _unreadCount = 0;
  StreamSubscription<int>? _unreadSub;

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
      final kantin = await fetchKantinByPenjual(userId);

      if (kantin != null) {
        await prefs.setInt('kantinId', kantin.id);
      }

      return kantin;
    } catch (e) {
      return null;
    }
  }

  void _ambilDataPenjual() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    fetchPenjual(userId!).then((Penjual hasil) {
      setState(() {
        penjual = hasil;
      });
    });
  }

  void _ambilProdukPenjual() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    _futureProduk = fetchProdukByPenjual(userId!);
  }

  void _ambilPesananKantin() async {
    final prefs = await SharedPreferences.getInstance();
    final kantinId = prefs.getInt('kantinId');

    if (kantinId == null) return;

    final orderans = await fetchOrderanByKantin(kantinId);
    final today = DateTime.now();

    int todayIncome = 0;
    int totalIncome = 0;
    int todayProductsSold = 0;
    int totalProductsSold = 0;

    for (final o in orderans) {
      // if (o.statusOrderan == 'batal' || o.statusOrderan == 'kadaluwarsa' || o.statusOrderan == 'menunggu_pembayaran') continue;
      if (o.statusOrderan == 'selesai') {
        final isToday = o.tanggalOrderan.year == today.year &&
            o.tanggalOrderan.month == today.month &&
            o.tanggalOrderan.day == today.day;
        final amount = o.totalHarga.toInt();

        totalIncome += amount;
        if (isToday) todayIncome += amount;

        for (final item in o.items) {
          final jumlah = item['jumlah'] as int;
          totalProductsSold += jumlah;
          if (isToday) todayProductsSold += jumlah;
        }
      }
    }

    if (!mounted) return;
    setState(() {
      _todayIncome = todayIncome;
      _totalIncome = totalIncome;
      _todayProductsSold = todayProductsSold;
      _totalProductsSold = totalProductsSold;
    });
    _isFirstLoadPesanan = false;
    _pesananController.add(orderans);
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final count = await fetchUnreadCount();
      if (mounted) setState(() => _unreadCount = count);
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    _ambilProdukPenjual();
    _ambilDataPenjual();
    _fetchUnreadCount();
    _unreadSub = NotificationService.unreadStream.listen((c) {
      if (mounted) setState(() => _unreadCount = c);
    });
    _futureKantin = _loadKantin().then((kantin) {
      if (kantin != null) {
        _ambilPesananKantin();
      }
      return kantin;
    });
    _initPath();
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) _ambilPesananKantin();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _pesananController.close();
    _unreadSub?.cancel();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    _ambilPesananKantin();
    _ambilDataPenjual();
    setState(() {
      _futureKantin = _loadKantin();
    });
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      setState(() {
        _futureProduk = fetchProdukByPenjual(userId);
      });
    }
  }

  void refreshDashboard() {
    setState(() {
      _futureKantin = _loadKantin();
    });
  }

  void refreshProduk() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      setState(() {
        _futureProduk = fetchProdukByPenjual(userId);
      });
    }
  }

  Widget _buildKantinImage(Kantin kantinData) {
    if (kantinData.fotoUrl != null && kantinData.fotoUrl!.isNotEmpty) {
      return Image.network(
        kantinData.fotoUrl!,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.image_not_supported_outlined,
            size: 60,
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
        size: 60,
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

  Widget _statusOrderan(String statusOrderan) {
    switch (statusOrderan) {
      case 'diproses':
        return Text(
          'Sedang diproses',
          style: TextStyle(color: Warna.warnaAccent, fontSize: 11),
        );
      case 'selesai':
        return Text(
          'Pesanan selesai',
          style: TextStyle(color: Colors.green, fontSize: 11),
        );
      case 'dibatalkan':
        return Text(
          'Pesanan dibatalkan',
          style: TextStyle(color: Colors.red, fontSize: 11),
        );
      case 'menunggu':
        return Text(
          'Menunggu Pengambilan',
          style: TextStyle(color: Colors.deepPurple, fontSize: 11),
        );
      case 'lunas':
        return Text(
          'Menunggu Konfirmasi',
          style: TextStyle(color: Colors.grey, fontSize: 11),
        );
      default:
        return Text(
          'Menunggu Konfirmasi',
          style: TextStyle(color: Colors.grey, fontSize: 11),
        );
    }
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
            return RefreshIndicator(
              onRefresh: _refreshAll,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (penjual != null)
                      TopBarHeaderPenjual(
                        penjual: penjual!,
                        unreadCount: _unreadCount,
                        returnFunction: () {
                          _ambilDataPenjual();
                        },
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
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Pendapatan(totalPendapatan: _totalIncome,))),
                              child: Column(
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
                                                  Icon(Icons.chevron_right,
                                                    size: 24,
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
                                                        NumberFormat.decimalPattern('id').format(_todayIncome),
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
                                                        NumberFormat.decimalPattern('id').format(_totalIncome),
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
                                          "$_todayProductsSold produk terjual hari ini",
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w200,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          "$_totalProductsSold total terjual",
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
                              )
                            ),
                            
                            //pesanan
                            StreamBuilder<List<Orderan>>(
                              stream: _pesananController.stream,
                              builder: (context, snapshot) {
                                final pesananLunas = (snapshot.data ?? [])
                                    .where((p) => p.statusOrderan == 'lunas')
                                    .toList();
                                final isLoading = !snapshot.hasData && _isFirstLoadPesanan;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 12.0,
                                  children: [
                                    //judul
                                    Row(
                                      children: [
                                        TextHeading(title: "Pesanan"),
                                        Spacer(),
                                        Text(
                                          "${pesananLunas.length} pesanan baru",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Warna.warnaAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isLoading)
                                      const Center(child: CircularProgressIndicator())
                                    else if (pesananLunas.isEmpty)
                                      Column(
                                        spacing: 10,
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
                                                "Saat ini belum ada pesanan untuk diterima",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Pesanan(),
                                                ),
                                              );
                                              _ambilPesananKantin();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Lihat Selengkapnya",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.chevron_right,
                                                      size: 20,
                                                    ),
                                                  ],
                                                ) 
                                                
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    else ...[
                                      ...pesananLunas
                                          .take(3)
                                          .map(
                                            (orderan) => Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Pesanan #${orderan.id}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        _statusOrderan(
                                                          orderan.statusOrderan,
                                                        ),
                                                        ...orderan.items.map(
                                                          (item) => Text(
                                                            "${item['jumlah']}x ${item['nama_produk']}",
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    "Rp. ${NumberFormat.decimalPattern('id').format(orderan.totalHarga)}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      GestureDetector(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Pesanan(),
                                            ),
                                          );
                                          _ambilPesananKantin();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Lihat Selengkapnya",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              },
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
                                  refreshProduk();
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
            ),
          );
        },
      ),
      ),
    );
  }
}
