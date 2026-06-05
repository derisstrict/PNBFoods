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

  late TextEditingController _nimController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController; 
  bool _isLoading = false;

   @override
  void initState() {
    super.initState();
    _nimController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

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
                        builder: (context) => ForgotPasswordPage(),
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
                        builder: (context) => ForgotPasswordPage(),
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

      final response = widget.role == 'pelanggan'
          ? await loginPelanggan(nim: _nimController.text, password: _passwordController.text)
          : await loginPenjual(email: _emailController.text, password: _passwordController.text);

      final token = response['token'];
      final data = response['data'];

      // simpan ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('user_id', data['id']);
      await prefs.setString('user_role', data['role']);

      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => data['role'] == 'pelanggan'
          ? ProfileUser(userId: data['id'], role: data['role']) //SEMENTARA INGET GANTI
          : ProfileUser(userId: data['id'], role: data['role']) //SEMENTARA INGET GANTI
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
