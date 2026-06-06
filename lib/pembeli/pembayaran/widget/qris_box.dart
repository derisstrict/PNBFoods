import 'package:flutter/material.dart';

class QrisBox extends StatelessWidget {
  final int totalHarga;
  final Color warnaOrange;
  final VoidCallback onSimpanQr;

  const QrisBox({
    super.key,
    required this.totalHarga,
    required this.warnaOrange,
    required this.onSimpanQr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'QRIS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('QRIS', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Image.network(
            'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=PNBFoods-Payment-$totalHarga',
            width: 200,
            height: 200,
            errorBuilder: (context, a, b) => Container(
              width: 200,
              height: 200,
              color: Colors.grey[200],
              child: const Icon(Icons.qr_code, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSimpanQr,
              icon: const Icon(Icons.download),
              label: const Text(
                'Simpan Kode QR',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: warnaOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}