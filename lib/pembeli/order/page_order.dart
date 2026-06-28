import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/orderan.dart';
import 'package:pnbfoods/services/orderan_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<List<Orderan>> _futureOrderan;

  @override
  void initState() {
    super.initState();
    _futureOrderan = _loadOrderan();
  }

  Future<List<Orderan>> _loadOrderan() async {
    final prefs = await SharedPreferences.getInstance();
    final pelangganId = await prefs.getInt('userId');

    if (pelangganId == null) throw Exception('User belum login');
    return fetchOrderanByPelanggan(pelangganId);
  }

  double _TotalHarian(List<Orderan> list) {
    return list.fold(0, (sum, item) => sum + item.totalHarga);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Warna.warnaAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        title: Stack(
          alignment: Alignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, color: Colors.white, size: 20),
                SizedBox(width: 5),
                Text(
                  'Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
        child: FutureBuilder(
          future: _futureOrderan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Belum ada riwayat orderan.'));
            }

            final listOrderan = snapshot.data!;
            final totalSemua = _TotalHarian(listOrderan);

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 18, right: 18, left: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        listOrderan.isNotEmpty
                            ? DateFormat(
                                'dd MMMM yyyy',
                              ).format(listOrderan.first.tanggalOrderan)
                            : '-',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Rp. ${NumberFormat('#.###').format(totalSemua)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listOrderan.length,
                  itemBuilder: (context, index) {
                    final orderan = listOrderan[index];

                    final namaKantin =
                        orderan.kantin?['nama_kantin'] ??
                        'Kantin Tidak Diketahui';

                    final kategoriKantin =
                        orderan.kantin?['kategori'] ?? 'Umum';

                    final fotoKantin = orderan.kantin?['foto_kantin'];

                    final List<Map<String, String>>
                    detailBelanja = orderan.items.map<Map<String, String>>((
                      item,
                    ) {
                      return {
                        'jumlah': "${item['jumlah']}",
                        'nama': item['nama_produk'].toString(),
                        'harga':
                            "Rp. ${NumberFormat('#.###').format(item['harga_subtotal'])}",
                      };
                    }).toList();

                    String waktu = DateFormat(
                      'HH.mm',
                    ).format(orderan.tanggalOrderan);

                    final jumlahItem = orderan.items.fold<int>(
                      0,
                      (sum, item) =>
                          sum + (int.tryParse(item['jumlah'].toString()) ?? 0),
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                          child: Text(
                            '$waktu',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        _buildOrderCard(
                          gambarkantin: fotoKantin,
                          namaKantin: namaKantin,
                          kategori: kategoriKantin,
                          itemCount: '$jumlahItem item',
                          totalHarga:
                              "Rp. ${NumberFormat('#.###').format(orderan.totalHarga)}",
                          status: orderan.statusOrderan,
                          items: detailBelanja,
                          statusPembayaran: orderan.statusPembayaran ?? '',
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _statusPembayaranWidget(String statusPembayaran) {
    switch (statusPembayaran) {
      case 'lunas':
        return Text(
          'Berhasil',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        );
      case 'gagal':
        return Text(
          'Gagal',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        );
      case 'menunggu_pembayaran':
        return Text(
          'Menunggu Pembayaran',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.orange,
          ),
        );
      case 'kadaluwarsa':
        return Text(
          'Kadaluwarsa',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        );
      default:
        return Text(
          statusPembayaran,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        );
    }
  }

  Widget _buildOrderCard({
    required String? gambarkantin,
    required String namaKantin,
    required String kategori,
    required String itemCount,
    required String totalHarga,
    required String status,
    required List<Map<String, String>> items,
    required String statusPembayaran,
  }) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: (gambarkantin != null)
                          ? Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade200,
                              child: Image.network(
                                gambarkantin,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.store, color: Colors.grey),
                              ),
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.store,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaKantin,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            kategori,
                            style: TextStyle(
                              fontSize: 12,
                              color: Warna.warnaTextGray,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                itemCount,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Warna.warnaTextGray,
                                ),
                              ),
                              Text(
                                '$totalHarga',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Warna.warnaAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildStatusBar(status),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Detail Belanja",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${item['jumlah']}x ${item['nama']}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          item['harga']!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                const Text(
                  "Metode Pembayaran",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      child: Image.asset(
                        'assets/img/qris.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 3),
                    Text(
                      "QRIS",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    _statusPembayaranWidget(statusPembayaran),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBar(String status) {
    Color bgColor;
    IconData icon;
    String label;

    switch (status) {
      case 'diproses':
        bgColor = Colors.orange;
        icon = Icons.access_time;
        label = 'Sedang diproses';
        break;
      case 'menunggu':
        bgColor = Colors.deepPurple;
        icon = Icons.check;
        label = 'Menunggu pengambilan';
        break;
      case 'selesai':
        bgColor = Colors.green;
        icon = Icons.check_circle_outline;
        label = 'Pesanan selesai';
        break;
      case 'batal':
        bgColor = Colors.red;
        icon = Icons.cancel_outlined;
        label = 'Pesanan dibatalkan';
        break;
      default:
        bgColor = Colors.grey;
        icon = Icons.info_outline;
        label = 'Menunggu konfirmasi';
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
