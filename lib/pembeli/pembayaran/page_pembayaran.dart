import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pnbfoods/common/tombol.dart';
import 'package:pnbfoods/common/top_bar.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/homepage/home.dart';
import 'package:pnbfoods/models/item_keranjang.dart';
import 'package:pnbfoods/models/pembayaran.dart';
import 'package:pnbfoods/pembeli/pembayaran/widget/countdown_kadaluwarsa.dart';
import 'package:pnbfoods/pembeli/pembayaran/widget/qris_box.dart';
import 'package:pnbfoods/pembeli/pembayaran/widget/tombol_pembayaran.dart';
import 'package:pnbfoods/services/cart_service.dart';
import 'package:pnbfoods/services/pembayaran_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PembayaranPage extends StatefulWidget {
  final int totalHarga;
  final List<ItemKeranjang> items;
  final int kantinId;
  final int? orderanId;

  const PembayaranPage({
    super.key,
    required this.totalHarga,
    required this.items,
    required this.kantinId,
    this.orderanId,
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  bool _isLoading = true;
  String? _errorMessage;
  int? _pembayaranId;
  String? _qrImageUrl;
  Pembayaran? _pembayaran;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _createPayment();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _createPayment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        setState(() => _errorMessage = 'Silakan login terlebih dahulu');
        return;
      }

      final result = await createSnapTransaction(
        pelangganId: userId,
        totalHarga: widget.totalHarga,
        kantinId: widget.kantinId,
        items: widget.items,
        orderanId: widget.orderanId,
      );

      final data = result['pembayaran'];
      _pembayaranId = data['id'] as int;
      _qrImageUrl = result['qr_image_url'] as String?;

      if (mounted) {
        setState(() => _isLoading = false);
        _startPolling();
        CartService().clear(kantinId: widget.kantinId);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (_pembayaranId == null) return;
      try {
        final p = await getPaymentStatus(_pembayaranId!);

        if (mounted) setState(() => _pembayaran = p);

        if (p.isTerminal) {
          _pollTimer?.cancel();

          if (p.isLunas) {
            _showDoneDialog("Pesanan Berhasil Dibuat", "Pembayaran anda telah berhasil. Silahkan ditunggu pesanan anda.", true);
          } else {
            final msg = p.statusPembayaran == 'kadaluwarsa'
                ? 'Waktu pembayaran telah habis.'
                : 'Pembayaran gagal. Silakan coba lagi.';
            _showDoneDialog('Pembayaran Gagal', msg, false);
          }
        }
      } catch (_) {}
    });
  }

  void _showDoneDialog(String title, String msg, bool success) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        icon: Icon(Icons.done, size: 58,),
        iconColor: Warna.warnaSuccess,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600,)),
        content: Text(msg, textAlign: TextAlign.center,),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TombolNavigasi(
            function: () {
              // Navigator.of(ctx).pop();
              // Navigator.of(context).pop(success);
              Navigator.pop(context, true);
            },
            text: "Kembali",
            backgroundColor: Warna.warnaAccent,
            foregroundColor: Colors.white, 
          ),
        ],
      ),
    );
  }

  int get _sisaDetik {
    if (_pembayaran?.expiredAt == null) return 900;
    return _pembayaran!.expiredAt!.difference(DateTime.now().toUtc()).inSeconds;
  }

  String get _formatWaktu {
    if (_sisaDetik <= 0) return '00:00:00';
    final jam = (_sisaDetik ~/ 3600).toString().padLeft(2, '0');
    final menit = ((_sisaDetik % 3600) ~/ 60).toString().padLeft(2, '0');
    final detik = (_sisaDetik % 60).toString().padLeft(2, '0');
    return '$jam:$menit:$detik';
  }

  String formatRupiah(int nilai) {
    final formatted = nilai.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp. $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: TopBar(title: "Pembayaran", icon: Icons.payment),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Menyiapkan pembayaran...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scan QRIS untuk membayar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            formatRupiah(widget.totalHarga),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          CountdownKadaluwarsa(formatWaktu: _formatWaktu),
          const SizedBox(height: 20),
          QrisBox(
            totalHarga: widget.totalHarga,
            qrImageUrl: _qrImageUrl,
          ),
          const SizedBox(height: 16),
          TombolPembayaran(
            onKembali: () => Navigator.pop(context, true),
          ),
          // if (_pembayaran != null)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 8),
          //     child: Text(
          //       'Status: ${_pembayaran!.statusPembayaran}',
          //       style: const TextStyle(color: Colors.grey, fontSize: 12),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
