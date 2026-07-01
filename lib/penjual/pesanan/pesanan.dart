import 'package:flutter/material.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/penjual/pesanan/widget/detail_pesanan.dart';
import 'package:pnbfoods/models/orderan.dart';
import 'package:pnbfoods/services/orderan_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pesanan extends StatefulWidget {
  @override
  State<Pesanan> createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  List<Orderan> _semuaPesanan = [];
  bool _isLoading = true;
  String _statusFilter = 'semua';

  Widget _tombolFilter(String label, String status) {
    final isActive = _statusFilter == status;
    return TextButton(
      onPressed: () => setState(() => _statusFilter = status),
      style: TextButton.styleFrom(
        backgroundColor: isActive ? Warna.warnaAccent : Colors.white,
        foregroundColor: isActive ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }

  @override
  void initState() {
    super.initState();
    _ambilPesanan();
  }

  void _ambilPesanan() async {
    final prefs = await SharedPreferences.getInstance();
    final kantinId = prefs.getInt('kantinId');
    if (kantinId != null) {
      final data = await fetchOrderanByKantin(kantinId);
      setState(() {
        _semuaPesanan = _urutkanPesanan(data);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  List<Orderan> _filterPesanan(List<Orderan> semua) {
    if (_statusFilter == 'semua') return semua;
    return semua.where((o) => o.statusOrderan == _statusFilter).toList();
  }

  int _prioritasStatus(String status) {
    switch (status) {
      case 'lunas':
        return 0;
      case 'diproses':
        return 1;
      case 'menunggu':
        return 2;
      case 'selesai':
        return 3;
      case 'batal':
        return 4;
      default:
        return 5;
    }
  }

  List<Orderan> _urutkanPesanan(List<Orderan> list) {
    final hasil = List<Orderan>.from(list);
    hasil.sort((a, b) {
      final prioritasA = _prioritasStatus(a.statusOrderan);
      final prioritasB = _prioritasStatus(b.statusOrderan);
      if (prioritasA != prioritasB) {
        return prioritasA.compareTo(prioritasB);
      }

      final tanggalA = a.createdAt ?? a.tanggalOrderan;
      final tanggalB = b.createdAt ?? b.tanggalOrderan;
      return tanggalB.compareTo(tanggalA);
    });
    return hasil;
  }

  void _handleStatusUpdated(int orderanId, String statusBaru) {
    setState(() {
      final idx = _semuaPesanan.indexWhere((o) => o.id == orderanId);
      if (idx != -1) {
        _semuaPesanan[idx] = _semuaPesanan[idx].copyWith(
          statusOrderan: statusBaru,
        );
        _semuaPesanan = _urutkanPesanan(_semuaPesanan);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pesanan = _filterPesanan(_semuaPesanan);

    // TODO: implement build
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      appBar: TopBar(title: "Pesanan"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      spacing: 8,
                      children: [
                        _tombolFilter('Semua', 'semua'),
                        _tombolFilter('Baru masuk', 'lunas'),
                        _tombolFilter('Proses', 'diproses'),
                        _tombolFilter('Menunggu', 'menunggu'),
                        _tombolFilter('Selesai', 'selesai'),
                      ],
                    ),
                  ),
                ),
                if (_isLoading)
                  Center(child: CircularProgressIndicator())
                else if (pesanan.isEmpty)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "Tidak ada pesanan",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    spacing: 10,
                    children: pesanan
                        .map(
                          (orderan) => DetailPesanan(
                            key: ValueKey(orderan.id),
                            orderan: orderan,
                            onStatusUpdated: (statusBaru) =>
                                _handleStatusUpdated(orderan.id, statusBaru),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
