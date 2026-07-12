import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnbfoods/common/forms.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/orderan.dart';
import 'package:pnbfoods/services/orderan_service.dart';

class DetailPesanan extends StatefulWidget {
  final Orderan orderan;
  final Function(String statusBaru)? onStatusUpdated;

  const DetailPesanan({super.key, required this.orderan, this.onStatusUpdated});

  @override
  State<DetailPesanan> createState() => _DetailPesananState();
}

class _DetailPesananState extends State<DetailPesanan> {
  void _ubahStatus(String statusBaru, {String? alasanPenolakan}) async {
    try {
      await updateOrderan(
        id: widget.orderan.id,
        statusOrderan: statusBaru,
        alasanPenolakan: alasanPenolakan,
      );

      if (!mounted) return;

      widget.onStatusUpdated?.call(statusBaru);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Status berhasil diperbarui menjadi $statusBaru"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String waktu = DateFormat('HH.mm').format(widget.orderan.tanggalOrderan);

    String menitYangLalu = _hitungWaktu(
      widget.orderan.createdAt ?? widget.orderan.tanggalOrderan,
    );

    final rupiah = NumberFormat.decimalPattern('id');

    return Column(
      spacing: 10,
      children: [
        Row(
          children: [
            Text(
              "$waktu - $menitYangLalu",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Row(
            spacing: 10.0,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color.fromARGB(91, 158, 158, 158),
                backgroundImage: widget.orderan.fotoProfile != null
                    ? NetworkImage(widget.orderan.fotoUrl!)
                    : null,

                child: widget.orderan.fotoProfile == null
                    ? Icon(Icons.person, size: 20, color: Colors.white)
                    : null,
              ),
              Text(
                widget.orderan.namaPelanggan ?? '-',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              Spacer(),
              Text(
                widget.orderan.nim ?? '-',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 3),
            ],
          ),
        ),
        _buildStatusBar(widget.orderan.statusOrderan),
        if (widget.orderan.statusOrderan == "batal")
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Alasan",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: 8,),
                Text(widget.orderan.alasanPenolakan ?? "-",
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Column(
            spacing: 5.0,
            children: [
              Row(
                children: [
                  Text(
                    "Detail Belanja",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Rp. ${NumberFormat.decimalPattern('id').format(widget.orderan.totalHarga)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Warna.warnaAccent,
                    ),
                  ),
                ],
              ),
              ...widget.orderan.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "${item['jumlah']}x ${item['nama_produk']}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            'Rp. ${rupiah.format(item['harga_subtotal'])}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
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
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Catatan: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
            ],
          ),
        ),
        Visibility(
          visible: widget.orderan.statusOrderan != 'selesai' && widget.orderan.statusOrderan != 'batal',
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Konfirmasi Pesanan",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
                Row(
                  children: [
                    TombolNavigasi(
                      function: () {
                        if (widget.orderan.statusOrderan == 'lunas') {
                          _konfirmasiUbahStatus('diproses');
                        } else if (widget.orderan.statusOrderan == 'diproses') {
                          _konfirmasiUbahStatus('menunggu');
                        } else if (widget.orderan.statusOrderan == 'menunggu') {
                          _konfirmasiUbahStatus('selesai');
                        }
                      },
                      backgroundColor: Warna.warnaAccent,
                      foregroundColor: Colors.white,
                      text: switch (widget.orderan.statusOrderan) {
                        'lunas' => 'Proses',
                        'diproses' => 'Pengambilan',
                        'menunggu' => 'Selesai',
                        _ => '',
                      },
                      icon: Icons.done,
                    ),
                    Spacer(),
                    TombolNavigasi(
                      function: () {
                        if (widget.orderan.statusOrderan == 'menunggu') {
                          _konfirmasiUbahStatus('diproses');
                        } else if (widget.orderan.statusOrderan == 'diproses') {
                          _konfirmasiUbahStatus('lunas');
                        } else {
                          _konfirmasiUbahStatus('batal');
                        }
                      },
                      backgroundColor: Colors.red[50]!,
                      foregroundColor: Colors.red,
                      text: switch (widget.orderan.statusOrderan) {
                        'lunas' => 'Tolak',
                        'diproses' => 'Batalkan',
                        'menunggu' => 'Batalkan',
                        _ => '',
                      },
                      icon: Icons.close,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _hitungWaktu(DateTime tanggal) {
    final sekarang = DateTime.now();
    final selisih = sekarang.difference(tanggal);

    if (selisih.inMinutes < 1) {
      return "baru saja";
    } else if (selisih.inMinutes < 60) {
      return "${selisih.inMinutes} menit yang lalu";
    } else if (selisih.inHours < 24) {
      return "${selisih.inHours} jam yang lalu";
    } else {
      return "${selisih.inDays} hari yang lalu";
    }
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
        label = 'Pesanan ditolak';
        break;
      case 'lunas':
        bgColor = Colors.grey;
        icon = Icons.info_outline;
        label = 'Menunggu konfirmasi';
        break;
      default:
        bgColor = Colors.grey;
        icon = Icons.info_outline;
        label = 'Menunggu konfirmasi';
    }

    return Container(
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

  Future<void> _konfirmasiUbahStatus(String statusBaru) async {
    final formController = TextEditingController();
    if (statusBaru != "batal") {
      formController.text = "-";
    }
    String text;
    switch (statusBaru) {
      case "diproses":
        text = "Ubah status bahwa pesanan sedang diproses?";
      case "menunggu":
        text = "Ubah status bahwa pesanan sudah siap untuk diambil?";
      case "selesai":
        text = "Selesaikan pesanan? Pastikan bahwa pembeli telah mengambil pesanan.";
      case "lunas":
        text = "Batalkan pemrosesan pesanan?";
      case "batal":
        text = "Apakah anda yakin ingin menolak pesanan?";
      default:
        text = "Apakah Anda yakin ingin mengubah status menjadi \"$statusBaru\"?";
    }
    final bool? konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Konfirmasi"),
            content: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                ),
                if (statusBaru == "batal")
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormFieldCustom(
                      controller: formController, 
                      labelText: "Alasan", 
                      prefixIcon: Icon(Icons.comment_outlined),
                      backgroundColor: Warna.warnaBackground,
                      onChanged: (text) {
                        setState(() {
                          
                        });
                      },
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              formController.text = "Produk yang anda pilih habis.";
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Warna.warnaBackground,
                            foregroundColor: Colors.black12
                          ), 
                          child: Text("Produk terpilih habis",
                            style: TextStyle(
                              color: Warna.warnaAccent
                            ),
                          )
                        ),    
                        TextButton(
                          onPressed: () {
                            setState(() {
                              formController.text = "";
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Warna.warnaBackground,
                            foregroundColor: Colors.black12
                          ), 
                          child: Row(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.backspace_outlined,
                              color: Warna.warnaAccent,),
                              Text("Hapus",
                                style: TextStyle(
                                  color: Warna.warnaAccent
                                ),
                              )
                            ],
                          ) 
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black
                    ),
                    child: const Text("Batal",
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: formController.text.isNotEmpty ? () {Navigator.pop(context, true);} : null,
                    style: TextButton.styleFrom(
                      backgroundColor: formController.text.isEmpty ? Warna.warnaAccent.withAlpha(85) : Warna.warnaAccent
                    ),
                    child: const Text("Ya",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        }); 
        
      },
    );
    if (konfirmasi == true) {
      _ubahStatus(
        statusBaru,
        alasanPenolakan: statusBaru == 'batal' ? formController.text : null,
      );
    }
  }
}
