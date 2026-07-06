import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnbfoods/common/palang_tamu.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/item_keranjang.dart';
import 'package:pnbfoods/models/orderan.dart';
import 'package:pnbfoods/pembeli/pembayaran/page_pembayaran.dart';
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
    // _futureOrderan = _loadOrderan();
  }

  Future _cekTamu() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<List<Orderan>> _loadOrderan() async {
    final prefs = await SharedPreferences.getInstance();
    final pelangganId = prefs.getInt('userId');

    if (pelangganId == null) throw Exception('User belum login');
    return fetchOrderanByPelanggan(pelangganId);
  }

  double _TotalHarian(List<Orderan> list) {
    return list.fold(0, (sum, item) => sum + item.totalHarga);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cekTamu(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          _futureOrderan = _loadOrderan();
          return Scaffold(
            appBar: TopBar(title: "Order", icon: Icons.article_outlined,),
            backgroundColor: Warna.warnaBackground,
            body: SafeArea(
              child: FutureBuilder<List<Orderan>>(
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

                  final listOrderanMentah = snapshot.data!;

                  final Map<String, List<Orderan>> groupedOrderan =
                      Orderan.orderanPertanggal(listOrderanMentah);
                  final List<String> listTanggal = groupedOrderan.keys.toList();

                  return ListView.builder(
                    itemCount: listTanggal.length,
                    itemBuilder: (context, indexTanggal) {
                      final tanggalRaw = listTanggal[indexTanggal];
                      final orderanPerHari = groupedOrderan[tanggalRaw]!;
                      final totalHarian = _TotalHarian(orderanPerHari);
                      final formatRupiah = NumberFormat.decimalPattern('id');

                      String tanggalFormatted = tanggalRaw;
                      try {
                        DateTime parsedDate = DateTime.parse(tanggalRaw);
                        tanggalFormatted = DateFormat(
                          'dd MMMM yyyy',
                        ).format(parsedDate);
                      } catch (_) {}

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 18,
                              right: 18,
                              left: 18,
                              bottom: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  tanggalFormatted,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Rp. ${formatRupiah.format(totalHarian)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ...orderanPerHari.map((orderan) {
                            final namaKantin =
                                orderan.kantin?['nama_kantin'] ??
                                'Kantin Tidak Diketahui';
                            final kategoriKantin =
                                orderan.kantin?['kategori'] ?? 'Umum';
                            final fotoKantin = orderan.kantin?['foto_url'];
                            final List<Map<String, String>>
                            detailBelanja = orderan.items.map<Map<String, String>>((
                              item,
                            ) {
                              return {
                                'jumlah': "${item['jumlah']}",
                                'nama': item['nama_produk'].toString(),
                                'harga':
                                    'Rp. ${formatRupiah.format(item['harga_subtotal'])}',
                                'catatan': item['catatan']?.toString() ?? '',
                              };
                            }).toList();

                            String waktu = DateFormat(
                              'HH.mm',
                            ).format(orderan.tanggalOrderan);

                            final jumlahItem = orderan.items.fold<int>(
                              0,
                              (sum, item) =>
                                  sum +
                                  (int.tryParse(item['jumlah'].toString()) ?? 0),
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 6),
                                  child: Text(
                                    waktu,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                _buildOrderCard(
                                  orderan: orderan,
                                  gambarkantin: fotoKantin,
                                  namaKantin: namaKantin,
                                  kategori: kategoriKantin,
                                  itemCount: '$jumlahItem item',
                                  totalHarga:
                                      'Rp. ${formatRupiah.format(orderan.totalHarga)}',
                                  status: orderan.statusOrderan,
                                  items: detailBelanja,
                                  statusPembayaran: orderan.statusPembayaran ?? '',
                                ),
                              ],
                            );
                          }),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        } else {
          return PalangTamu(text: 'Silahkan login untuk dapat melihat daftar order anda',);
        }
      }
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
    required Orderan orderan,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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

                        if (item['catatan'] != null &&
                            item['catatan'].toString().trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "Catatan: ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: item['catatan']),
                                ],
                              ),
                            ),
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
        if (status == "menunggu_pembayaran")
          GestureDetector(
            onTap: () async {
              final resumeItems = orderan.items.map<ItemKeranjang>((item) {
                final jumlah = item['jumlah'] as int;
                final subtotal = item['harga_subtotal'] as int;
                return ItemKeranjang(
                  produkId: item['id_produk'] as int?,
                  nama: item['nama_produk'] as String,
                  harga: jumlah > 0 ? subtotal ~/ jumlah : 0,
                  jumlah: jumlah,
                  catatan: item['catatan'] as String?,
                  imageUrl: '',
                );
              }).toList();

              final result = await Navigator.push<bool>(context, MaterialPageRoute(
                builder: (context) => PembayaranPage(
                  totalHarga: orderan.totalHarga.toInt(),
                  items: resumeItems,
                  kantinId: orderan.kantin?['id'] as int,
                  orderanId: orderan.id,
                ),
              ));
              if (result == true) {
                setState(() {
                  _futureOrderan = _loadOrderan();
                });
              }
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Warna.warnaAccent,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Icon(Icons.qr_code_scanner, color: Colors.white,),
                  Text("Lanjutkan pembayaran",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
                ],
              ),
            ),
          )
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
      case 'kadaluwarsa':
        bgColor = Colors.red;
        icon = Icons.cancel_outlined;
        label = 'Pembayaran gagal';
        break;
      case 'menunggu_pembayaran':
        bgColor = Colors.blue;
        icon = Icons.timer_outlined;
        label = 'Menunggu pembayaran';
        break;
      case 'lunas':
        bgColor = Colors.grey;
        icon = Icons.info_outline;
        label = 'Menunggu konfirmasi penjual';
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
