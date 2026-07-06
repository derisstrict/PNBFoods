import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:pnbfoods/common/forms.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/penjual/dashboard/widgets/text_heading.dart';
import 'package:pnbfoods/services/penjual_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pendapatan extends StatefulWidget {
  final int totalPendapatan;

  const Pendapatan({super.key, required this.totalPendapatan});

  State<Pendapatan> createState() => _PendapatanState();
}

class _PendapatanState extends State<Pendapatan> {
  int _saldo = 0;
  bool _isLoading = true;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSaldo();
  }

  Future<void> _loadSaldo() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;
    try {
      final saldo = await fetchSaldo(userId);
      if (mounted) setState(() { _saldo = saldo; _isLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleTarikUang() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    final jumlah = int.tryParse(_amountController.text);
    if (jumlah == null || jumlah < 1) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan jumlah yang valid')),
        );
      }
      return;
    }

    if (jumlah > _saldo) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saldo tidak mencukupi')),
        );
      }
      return;
    }

    try {
      await tarikSaldo(userId, jumlah);
      final saldoBaru = await fetchSaldo(userId);
      if (mounted) {
        setState(() { _saldo = saldoBaru; });
        _amountController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Penarikan berhasil diproses')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e')),
        );
      }
    }
  }

  String formatRupiah(int nilai) {
    final formatted = nilai.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp. $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      appBar: TopBar(title: "Pendapatan"),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Icon(Icons.account_balance_wallet),
                              Text(
                                "Saldo kamu",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                    _isLoading ? "-" : NumberFormat.decimalPattern('id').format(_saldo),
                                    style: TextStyle(
                                      fontSize: 34.0,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total pendapatan anda ${formatRupiah(widget.totalPendapatan)}",
                            style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w200,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25,),
                    TextHeading(title: "Penarikan"),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Column(
                        spacing: 12,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Metode penarikan",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: 4,),
                                    Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Bank_Central_Asia.svg/330px-Bank_Central_Asia.svg.png",
                                      height: 12,
                                      fit: BoxFit.cover, 
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 12,
                                        height: 12,
                                        color: Warna.warnaBackground,
                                        child: Icon(Icons.image_not_supported, size: 20, color: Colors.black,),
                                      )
                                    ),
                                  ],
                                ),
                                SizedBox(width: 5,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("BCA",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    Row(
                                      spacing: 3,
                                      children: [
                                        Icon(Icons.info_outline,
                                          size: 16,
                                          color: Warna.warnaTextGray,
                                        ),
                                        Text("Dana akan tiba dalam 1 hari kerja",
                                          style: TextStyle(
                                            fontSize: 11
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 8,),
                                    Icon(Icons.chevron_right)
                                  ],
                                )
                              ],
                            ),
                          ),

                          Text("Jumlah",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                            ),
                          ),

                          TextFormFieldCustom(
                            controller: _amountController, 
                            labelText: "Nominal", 
                            prefixIcon: Padding(
                              padding: EdgeInsetsGeometry.only(top: 13, left: 10, bottom: 12),
                              child: Text("Rp.",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Warna.warnaAccent
                                ),),
                            ),
                            numberOnly: true,
                            backgroundColor: Warna.warnaBackground,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _amountController.text = _saldo.toString();
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Warna.warnaBackground,
                                  foregroundColor: Colors.black12
                                ), 
                                child: Text("Tarik semua",
                                  style: TextStyle(
                                    color: Warna.warnaAccent
                                  ),
                                )
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _amountController.text = "${_amountController.text}00";
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Warna.warnaBackground,
                                  foregroundColor: Colors.black12
                                ), 
                                child: Text("00",
                                  style: TextStyle(
                                    color: Warna.warnaAccent
                                  ),
                                )
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _amountController.text = "${_amountController.text}000";
                                  });
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Warna.warnaBackground,
                                  foregroundColor: Colors.black12
                                ), 
                                child: Text("000",
                                  style: TextStyle(
                                    color: Warna.warnaAccent
                                  ),
                                )
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 40,
                                child: TextButton.icon(
                                  onPressed: () => _handleTarikUang(), 
                                  style: TextButton.styleFrom(
                                    backgroundColor: Warna.warnaAccent,
                                    foregroundColor:  Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.circular(15)
                                    )
                                  ),
                                  label: Text("Tarik uang",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  icon: Icon(Icons.payments_outlined),
                                ),
                              )
                              
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
            
          }
        )
      ) 
    );
  }
}