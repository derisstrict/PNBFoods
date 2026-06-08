import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pesananList = [
      {
        'waktu': '12.38 PM',
        'gambarkantin': 'assets/img/logo.png',
        'namaKantin': 'Kantin Ibu Gacor',
        'kategori': 'Makanan & Minuman',
        'itemCount': '3 item',
        'totalHarga': '68.000',
        'status': 'selesai',
        'items': [
          {'nama': 'Nasi Goreng Spesial', 'jumlah': '2','harga': '50.000'},
          {'nama': 'Tipat Cantok', 'jumlah': '1', 'harga': '18.000'},
        ],
        'statusPembayaran': 'Berhasil',
      },
      {
        'waktu': '12.32 PM',
        'gambarkantin': null,
        'namaKantin': 'Kantin Ibu Gacor',
        'kategori': 'Makanan & Minuman',
        'itemCount': '1 item',
        'totalHarga': '18.000',
        'status': 'proses',
        'items': [
          {'nama': 'Nasi Pecel', 'jumlah': '1', 'harga': '18.000'},
        ],
        'statusPembayaran': 'Berhasil',
      },
      {
        'waktu': '12.32 PM',
        'gambarkantin': null,
        'namaKantin': 'Kantin Ibu Gacor',
        'kategori': 'Makanan & Minuman',
        'itemCount': '1 item',
        'totalHarga': '18.000',
        'status': 'tunggu',
        'items': [
          {'nama': 'Nasi Pecel', 'jumlah': '1', 'harga': '18.000'},
        ],
        'statusPembayaran': 'Berhasil',
      },
      {
        'waktu': '12.32 PM',
        'gambarkantin': null, 
        'namaKantin': 'Kantin Ibu Gacor',
        'kategori': 'Makanan & Minuman',
        'itemCount': '1 item',
        'totalHarga': '18.000',
        'status': 'batal',
        'items': [
          {'nama': 'Nasi Pecel', 'jumlah': '1', 'harga': '18.000'},
        ],
        'statusPembayaran': 'Gagal',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Warna.warnaAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))
        ),
        title: Stack(
          alignment: Alignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, color: Colors.white, size: 20),
                SizedBox(width: 5),
                Text('Order', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))
              ],
            )
          ],
        )
      ),
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18, right: 18, left: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('30 Juni 2021',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text('Rp. 89.000',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pesananList.length,
              itemBuilder: (context, index) {
                final pesanan = pesananList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Padding(
                        padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                        child: Text(pesanan['waktu'],
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    _buildOrderCard(
                      gambarkantin: pesanan['gambarkantin'],
                      namaKantin: pesanan['namaKantin'],
                      kategori: pesanan['kategori'],
                      itemCount: pesanan['itemCount'],
                      totalHarga: pesanan['totalHarga'],
                      status: pesanan['status'],
                      items: List<Map<String, String>>.from(pesanan['items']),
                      statusPembayaran: pesanan['statusPembayaran'],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
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
                            height: 60  ,
                            color: Colors.grey.shade200,
                            child: Image.asset(gambarkantin, fit: BoxFit.cover),
                          )
                        : Container(
                          width: 60,
                          height: 60  ,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.store, color: Colors.grey),
                        ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(namaKantin,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          Text(kategori,
                            style: TextStyle(fontSize: 12, color: Warna.warnaTextGray),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(itemCount,
                                style: TextStyle(fontSize: 12, color: Warna.warnaTextGray),
                              ),
                              Text('Rp. $totalHarga',
                                style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600, color: Warna.warnaAccent,
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
                const Text("Detail Belanja",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item['jumlah']}x ${item['nama']}",
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      Text(item['harga']!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                )),
                const Divider(),
                const Text("Metode Pembayaran",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      child: Image.asset('assets/img/qris.png',  
                      fit: BoxFit.cover),
                    ),
                    SizedBox(width: 3),
                    Text("QRIS",
                      style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    
                    Text(statusPembayaran,
                      style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: statusPembayaran == 'Berhasil' 
                          ? Colors.green
                          : Colors.red,
                      ),
                    ),
                  ],
                ),
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
      case 'proses':
        bgColor = Colors.orange;
        icon = Icons.access_time;
        label = 'Sedang diproses';
        break;
      case 'tunggu':
        bgColor = Colors.deepPurple;
        icon = Icons.check;
        label = 'Menunggu pengambilan';
        break;
      case 'selesai':
        bgColor =Colors.green;
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
        label = 'Status tidak diketahui';
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
          Text(label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
          ),
        ],
      ),
    );
  }
}