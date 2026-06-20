import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pnbfoods/common/warna.dart';

class QrisBox extends StatelessWidget {
  final int totalHarga;
  final String? qrImageUrl;

  const QrisBox({
    super.key,
    required this.totalHarga,
    this.qrImageUrl,
  });

  String formatRupiah(int nilai) {
    final formatted = nilai.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp. $formatted';
  }

  Future<void> _downloadQr(BuildContext context) async {
    if (qrImageUrl == null) return;

    try {
      final response = await Dio().get(
        qrImageUrl!,
        options: Options(responseType: ResponseType.bytes),
      );

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/qris_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(response.data);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kode QR berhasil disimpan')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan QR: $e')),
        );
      }
    }
  }

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
          if (qrImageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                qrImageUrl!,
                width: 300,
                height: 300,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 200,
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.qr_code, size: 100),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            )
          else
            Container(
              width: 200,
              height: 200,
              color: Colors.grey[200],
              child: const Icon(Icons.qr_code, size: 100),
            ),
          const SizedBox(height: 8),
          Text(
            formatRupiah(totalHarga),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: qrImageUrl != null
                  ? () => _downloadQr(context)
                  : null,
              icon: const Icon(Icons.download),
              label: const Text(
                'Simpan Kode QR',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Warna.warnaAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: TextButton.icon(
              onPressed: qrImageUrl != null
                  ? () {
                      Clipboard.setData(ClipboardData(text: qrImageUrl!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link QR berhasil disalin')),
                      );
                    }
                  : null,
              icon: const Icon(Icons.copy),
              label: const Text(
                'Salin Link QR',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[700],
                foregroundColor: Colors.white,
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
