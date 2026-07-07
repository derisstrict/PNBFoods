import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/notifikasi.dart';
import 'package:pnbfoods/pembeli/order/page_order.dart';
import 'package:pnbfoods/penjual/pesanan/pesanan.dart';
import 'package:pnbfoods/services/notifikasi_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Notifikasi extends StatefulWidget {
  const Notifikasi({super.key});

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  List<NotifikasiModel> _notifikasi = [];
  bool _isLoading = true;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString('role');
    _loadNotifikasi();
  }

  Future<void> _loadNotifikasi() async {
    try {
      final data = await fetchNotifikasi();
      if (mounted) {
        setState(() {
          _notifikasi = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _markAsRead(NotifikasiModel notif) async {
    if (notif.isRead) return;

    try {
      await markNotifikasiAsRead(notif.id);
    } catch (_) {}

    if (mounted) {
      setState(() {
        final idx = _notifikasi.indexWhere((n) => n.id == notif.id);
        if (idx != -1) {
          _notifikasi[idx] = NotifikasiModel(
            id: notif.id,
            orderanId: notif.orderanId,
            judul: notif.judul,
            isi: notif.isi,
            isRead: true,
            kantinNama: notif.kantinNama,
            createdAt: notif.createdAt,
          );
        }
      });
    }

    if (mounted && notif.orderanId != null) {
      if (_role == 'penjual') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Pesanan()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrderPage()),
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await markAllNotifikasiAsRead();
    } catch (_) {}

    if (mounted) {
      setState(() {
        _notifikasi = _notifikasi
            .map((n) => NotifikasiModel(
                  id: n.id,
                  orderanId: n.orderanId,
                  judul: n.judul,
                  isi: n.isi,
                  isRead: true,
                  kantinNama: n.kantinNama,
                  createdAt: n.createdAt,
                ))
            .toList();
      });
    }
  }

  String _formatWaktu(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return DateFormat('dd MMM yyyy, HH.mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.warnaBackground,
      appBar: AppBar(
        backgroundColor: Warna.warnaAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context, true),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_outlined, size: 20),
            const SizedBox(width: 5),
            const Text("Notifikasi", style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: _notifikasi.any((n) => !n.isRead)
            ? [
                IconButton(
                  onPressed: _markAllAsRead,
                  icon: const Icon(Icons.done_all, color: Colors.white),
                  tooltip: 'Tandai semua sudah dibaca',
                ),
              ]
            : null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _notifikasi.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada notifikasi',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadNotifikasi,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _notifikasi.length,
                      itemBuilder: (context, index) {
                        final notif = _notifikasi[index];
                        return _buildNotifikasiCard(notif);
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildNotifikasiCard(NotifikasiModel notif) {
    return GestureDetector(
      onTap: () => _markAsRead(notif),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications,
              color: notif.isRead ? Colors.grey : Colors.black,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notif.judul,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: notif.isRead ? Colors.black54 : Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        _formatWaktu(notif.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: notif.isRead ? Colors.grey : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  if (notif.kantinNama != null && _role == "pelanggan") ...[
                    // const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.storefront,
                          size: 14,
                          color: notif.isRead ? Colors.grey : Colors.black,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          notif.kantinNama!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: notif.isRead ? Colors.grey : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    notif.isi,
                    style: TextStyle(
                      fontSize: 13,
                      color: notif.isRead ? Colors.grey : Colors.black,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
