import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/services/pelanggan_service.dart';
import 'package:pnbfoods/services/penjual_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String role;

  ForgotPasswordPage({super.key, required this.role});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController nimController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController konfirmasiController = TextEditingController();
  bool _obscurePass = true;
  bool _obscureKonfirmasi = true;

  @override
  void dispose() {
    nimController.dispose();
    emailController.dispose();
    passController.dispose();
    konfirmasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(child: Image.asset('assets/img/Logo.png', height: 200)),
              const SizedBox(height: 30),

              // Judul
              const Text(
                "Lupa Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Password baru kamu harus berbeda dari password kamu sebelumnya",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // NIM
              TextFormField(
                controller: widget.role == 'pelanggan' ? nimController : emailController,
                keyboardType: widget.role == 'pelanggan' 
                  ? TextInputType.number 
                  : TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: widget.role == 'pelanggan' ? "NIM" : "Email",
                  filled: true,
                  fillColor: Colors.grey.shade100,
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
              const SizedBox(height: 15),

              // Password Baru
              TextFormField(
                controller: passController,
                obscureText: _obscurePass,
                decoration: InputDecoration(
                  labelText: "Password Baru",
                  filled: true,
                  fillColor: Colors.grey.shade100,
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
              const SizedBox(height: 15),

              // Konfirmasi Password
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
                  fillColor: Colors.grey.shade100,
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Warna.warnaAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    // logic reset password
                    _confirmResetPassword(context);
                  },
                  child: const Text(
                    "Tetapkan Password Baru",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmResetPassword(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Reset Password', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 16.0)),
          content: Text('Apakah Anda yakin ingin mengubah password?', style: TextStyle(fontSize: 14, color: Colors.black87)),
          actions: <Widget>[
            TextButton(
              child: Text('Batal', style: TextStyle(color: Colors.black87)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Reset', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // _resetPassword();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> _resetPassword() async {
  //   try {
  //     if (widget.role == 'pelanggan') {
  //       await forgotPasswordPelanggan(
  //         nim: nimController.text,
  //         password: passController.text,
  //       );
  //     } else {
  //       await forgotPasswordPenjual(
  //         email: emailController.text,
  //         password: passController.text,
  //       );
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Password berhasil direset!'), backgroundColor: Colors.green),
  //     );
  //     Navigator.pop(context);

  //   } on DioException catch (e) {
  //     final pesan = e.response?.data['message'] ?? 'Gagal reset password';
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(pesan), backgroundColor: Colors.red),
  //     );
  //   }
  // }
}