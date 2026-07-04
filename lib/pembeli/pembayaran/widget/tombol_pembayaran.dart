import 'package:flutter/material.dart';

class TombolPembayaran extends StatelessWidget {
  final VoidCallback onKembali;

  const TombolPembayaran({
    super.key,
    required this.onKembali,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        const Text(
          'Ketuk "Simpan Kode QR" atau ambil tangkapan layar untuk menyimpan kode QR ke ponsel Anda.',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 12),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: TextButton(
            onPressed: onKembali,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black12,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Kembali',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}