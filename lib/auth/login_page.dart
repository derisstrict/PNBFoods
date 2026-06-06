import 'package:flutter/material.dart';
import 'package:pnbfoods/akun/akun_user.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/common/login_form.dart'; 
import 'package:pnbfoods/auth/forgot_password_page.dart';
import 'package:pnbfoods/pembeli/list_produk/list_produk.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 40,
          ), // ← atur angka ini
          child: Column(
            children: [
              // Logo
              Image.asset('assets/img/Logo.png', height: 200),
              const SizedBox(height: 40),

              // Judul
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
      ),
    );
  }
  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {

     widget.role == 'pelanggan'
          ? await loginPelanggan(nim: _nimController.text, password: _passwordController.text)
          : await loginPenjual(email: _emailController.text, password: _passwordController.text);

      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('role');
      final userId = prefs.getInt('userId');


      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => role == 'pelanggan'
          ? ProfileUser(userId: userId!, role: role!) //SEMENTARA INGET GANTI
          : ProfileUser(userId: userId!, role: role!) //SEMENTARA INGET GANTI
        ),
      );

    } on DioException catch (e) {
      final pesan = e.response?.data['message'] ?? 'Login gagal';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(pesan), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
