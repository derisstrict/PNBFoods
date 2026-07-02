import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/pelanggan.dart';
import 'package:pnbfoods/models/penjual.dart';
import 'package:pnbfoods/services/pelanggan_service.dart';
import 'package:pnbfoods/services/penjual_service.dart';

class UbahPassword extends StatefulWidget {
  final Pelanggan? pelanggan;
  final Penjual? penjual;

  const UbahPassword({super.key, this.pelanggan, this.penjual});

  @override
  State<UbahPassword> createState() => _UbahPasswordState();
}

class _UbahPasswordState extends State<UbahPassword> {
  final TextEditingController passLamaController = TextEditingController();
  final TextEditingController passBaruController = TextEditingController();
  final TextEditingController konfirmasiController = TextEditingController();
  bool _obscurePass = true;
  bool _obscureKonfirmasi = true;

  @override
  void dispose() {
    passLamaController.dispose();
    passBaruController.dispose();
    konfirmasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      appBar: TopBar(title: "Ubah Password", icon: Icons.lock_outline,),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(child: Image.asset('assets/img/logo.png', height: 100)),
              const SizedBox(height: 30),
              // Judul
              const Text(
                "Ubah Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Password baru kamu harus berbeda dari password kamu sebelumnya",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 15),

              //Password lama
              TextFormField(
                controller: passLamaController,
                obscureText: _obscureKonfirmasi,
                decoration: InputDecoration(
                  labelText: "Password Lama",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureKonfirmasi ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureKonfirmasi = !_obscureKonfirmasi;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //Password baru
              TextFormField(
                controller: passBaruController,
                obscureText: _obscureKonfirmasi,
                decoration: InputDecoration(
                  labelText: "Password Baru",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureKonfirmasi ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureKonfirmasi = !_obscureKonfirmasi;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              //Konfirmasi Password baru
              TextFormField(
                controller: konfirmasiController,
                obscureText: _obscureKonfirmasi,
                decoration: InputDecoration(
                  labelText: "Konfirmasi Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureKonfirmasi ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureKonfirmasi = !_obscureKonfirmasi;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hoverColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Tombol
              Container(
                child: Row(
                  children: [
                    TombolNavigasi(function: () {Navigator.pop(context);}, backgroundColor: Colors.white, foregroundColor: Colors.black, text: "Kembali"),
                    Spacer(),
                    TombolNavigasi(
                      function: () => _confirmChangePassword(context),
                      backgroundColor: Warna.warnaAccent, 
                      foregroundColor: Colors.white,
                      icon: Icons.check, 
                      text: "Simpan"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmChangePassword(BuildContext context) async {
    if (passLamaController.text.isEmpty || passBaruController.text.isEmpty || konfirmasiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom form wajib diisi!'), backgroundColor: Colors.orange),
      );
      return;
    }

    if (passBaruController.text != konfirmasiController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password baru tidak cocok!'), backgroundColor: Colors.orange),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Ubah Password', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 16.0)),
          content: Text('Apakah Anda yakin ingin mengubah password?', style: TextStyle(fontSize: 14, color: Colors.black87)),
          actions: <Widget>[
            TextButton(
              child: Text('Batal', style: TextStyle(color: Colors.black87)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ubah', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _changePassword();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword() async {
    try {
      if (widget.pelanggan != null) {
        await changePasswordPelanggan(
          passwordLama: passLamaController.text,
          passwordBaru: passBaruController.text,
          passwordKonfirmasi: konfirmasiController.text,
        );
      } else {
        await changePasswordPenjual(
          passwordLama: passLamaController.text,
          passwordBaru: passBaruController.text,
          passwordKonfirmasi: konfirmasiController.text,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password berhasil diubah!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);

    } on DioException catch (e) {
      final pesan = e.response?.data['message'] ?? 'Gagal ubah password';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pesan), backgroundColor: Colors.red),
      );
    }
  }
}