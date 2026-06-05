import 'package:flutter/material.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/common/login_form.dart'; 
import 'package:pnbfoods/auth/forgot_password_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController nimController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  LoginPage({super.key});

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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Silahkan Masukkan dengan NIM",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              LoginForm(
                nimController: nimController,
                passController: passController,
                onLogin: () {},
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
}
