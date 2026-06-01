import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pnbfoods/common/warna.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController nimController;
  final TextEditingController passController;
  final VoidCallback onLogin;
  final VoidCallback onLupaPassword;

  const LoginForm({
    super.key,
    required this.nimController,
    required this.passController,
    required this.onLogin,
    required this.onLupaPassword,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePass = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input NIM
        TextFormField(
          controller: widget.nimController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: "NIM",
            prefixIcon: const Icon(Icons.phone_android, color: Colors.orange),
            filled: true,
            fillColor: Colors.grey.shade100,
            labelStyle: const TextStyle(fontSize: 16),
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

        // Input Password
        TextFormField(
          controller: widget.passController,
          obscureText: _obscurePass,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.orange),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePass ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePass = !_obscurePass;
                });
              },
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            labelStyle: const TextStyle(fontSize: 16),
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
        // Lupa Password
        Center(
          child: TextButton(
            onPressed: widget.onLupaPassword,
            child: Text(
              "Lupa Password?",
              style: TextStyle(color: Warna.warnaAccent),
            ),
          ),
        ),
        const SizedBox(height: 15),

        // Tombol Masuk
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
            onPressed: widget.onLogin,
            child: const Text(
              "Masuk",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}