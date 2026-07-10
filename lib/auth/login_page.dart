import 'package:flutter/material.dart';
import 'package:pnbfoods/akun/akun_user.dart';
import 'package:pnbfoods/auth/autentikasi.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/common/login_form.dart'; 
import 'package:pnbfoods/auth/forgot_password_page.dart';
import 'package:pnbfoods/homepage/home.dart';
import 'package:pnbfoods/pembeli/list_produk/list_produk.dart';
import 'package:pnbfoods/server/pengaturan_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:pnbfoods/services/pelanggan_service.dart';
import 'package:pnbfoods/services/penjual_service.dart';

class LoginPage extends StatefulWidget {
  final String role;

  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ), // ← atur angka ini
          child: Column(
            children: [
              // Logo
              GestureDetector(
                onDoubleTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PengaturanServer())),
                child: Image.asset('assets/img/logo.png', height: 200),
              ),

              const SizedBox(height: 40),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      runAlignment: WrapAlignment.spaceEvenly,
                      alignment: WrapAlignment.center,
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(role: 'pelanggan')));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: widget.role == 'pelanggan' ? Warna.warnaAccent : Colors.white,
                            foregroundColor: widget.role == 'pelanggan' ? Colors.white : Colors.black
                          ), 
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person),
                              Text("Login pengguna", 
                                style: TextStyle(
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          )
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(role: 'penjual')));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: widget.role == 'penjual' ? Warna.warnaAccent : Colors.white,
                            foregroundColor: widget.role == 'penjual' ? Colors.white : Colors.black
                          ), 
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.store_mall_directory),
                              Text("Login penjual", 
                                style: TextStyle(
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ) 
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Masuk",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.role == 'pelanggan'
                          ? "Silahkan masuk dengan NIM"
                          : "Silahkan masuk dengan Email",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                    else if (widget.role == 'pelanggan')
                      LoginForm(
                        controller: _nimController,
                        passController: _passwordController,
                        labelForm: "NIM",
                        onLogin: _login,
                        onLupaPassword: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(role: 'pelanggan'),
                            ),
                          );
                        },
                      )
                    else 
                      LoginForm(
                        controller: _emailController,
                        passController: _passwordController,
                        labelForm: "Email",
                        onLogin: _login,
                        onLupaPassword: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(role: 'penjual'),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              if (widget.role == 'pelanggan')
              Column(
                children: [
                  SizedBox(height: 10,),
                  TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('role', 'pelanggan');
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePengguna()));
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Warna.warnaAccent
                    ),
                    child: Text("Login sebagai tamu",
                      style: TextStyle(
                        fontWeight: FontWeight.w400
                      ),
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {

     widget.role == 'pelanggan'
          ? await loginPelanggan(nim: _nimController.text, password: _passwordController.text)
          : await loginPenjual(email: _emailController.text, password: _passwordController.text);

      // final prefs = await SharedPreferences.getInstance();
      // final role = prefs.getString('role');
      // final userId = prefs.getInt('userId');

      // Navigator.pushReplacement(context,
      //   MaterialPageRoute(builder: (context) => role == 'pelanggan'
      //     ? ProfileUser() //SEMENTARA INGET GANTI
      //     : ProfileUser() //SEMENTARA INGET GANTI
      //   ),
      // );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Autentikasi()));

    } on DioException catch (e) {
      final String pesan = e.response?.data['message'] ?? 'Login gagal';
      if (pesan.contains("field") && pesan.contains("required")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Belum semua form terisi"), backgroundColor: Colors.red),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pesan), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
