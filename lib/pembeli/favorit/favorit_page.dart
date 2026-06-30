import 'package:flutter/material.dart';
import 'package:pnbfoods/common/palang_tamu.dart';
import 'package:pnbfoods/common/warna.dart';
import 'package:pnbfoods/models/kantin.dart';
import 'package:pnbfoods/models/produk.dart';
import 'package:pnbfoods/pembeli/list_produk/list_produk.dart';
import 'package:pnbfoods/services/favorit_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  late Future<List<Map<String, dynamic>>> _futureFavorit;
  late Future<int> idPengguna;

  @override
  void initState() {
    super.initState();
    _futureFavorit = getFavorit();
  }

  Future _cekTamu() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  void _refresh() {
    setState(() {
      _futureFavorit = getFavorit();
    });
  }

  String _formatRupiah(dynamic amount) {
    final int nilai = (double.tryParse(amount.toString()) ?? 0).toInt();
    final str = nilai.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }
    return 'Rp. ${buffer.toString().split('').reversed.join()}';
  }

  Future<void> _hapusFavorit(int favoritId) async {
    try {
      await hapusFavorit(favoritId);
      _refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dihapus dari favorit'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e')),
        );
      }
    }
  }

  void _keKantin(Map<String, dynamic> produkData, Map<String, dynamic> kantinData) {
    // Buat object Produk dari data API
    final produk = Produk(
      id: produkData['id'] as int,
      namaProduk: produkData['nama_produk'] as String,
      fotoProduk: produkData['foto_produk'] as String?,
      fotoUrl: produkData['foto_url'] as String?,
      deskripsiProduk: produkData['deskripsi_produk'] as String?,
      kategoriProduk: produkData['kategori_produk'] as String,
      hargaProduk: (double.tryParse(produkData['harga_produk'].toString()) ?? 0).toInt(),
      stok: produkData['stok'] as int,
    );

    // Buat object Kantin dari data API
    final kantin = Kantin(
      id: kantinData['id'] as int,
      namaKantin: kantinData['nama_kantin'] as String,
      fotoKantin: kantinData['foto_kantin'] as String?,
      fotoUrl: kantinData['foto_url'] as String?,
      kategori: kantinData['kategori'] as String,
      idPenjual: kantinData['penjual_id'] as int,
    );

    // Navigate ke ListProduk dan langsung buka DeskripsiMakanan
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListProduk(
          kantin: kantin,
          produkAwal: produk, // langsung buka pop up produk ini
        ),
      ),
    ).then((_) => _refresh());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cekTamu(), 
      builder: (builder, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Warna.warnaBackground,
            body: SafeArea(
              child: Column(
                children: [
                  // Header oranye
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: Warna.warnaAccent,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Favorit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _futureFavorit,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                                const SizedBox(height: 8),
                                Text(
                                  'Gagal memuat favorit\n${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: _refresh,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          );
                        }

                        final favoritList = snapshot.data ?? [];

                        if (favoritList.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 12),
                                Text(
                                  'Belum ada favorit',
                                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${favoritList.length} Item',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: favoritList.length,
                                itemBuilder: (context, index) {
                                  final item = favoritList[index];
                                  final produk = item['produk'] as Map<String, dynamic>;
                                  final kantin = produk['kantin'] as Map<String, dynamic>?;
                                  final favoritId = item['id'] as int;
                                  final jumlahFavorit = produk['jumlah_favorit'] ?? 0;
                                  final fotoUrl = produk['foto_url'] as String?;

                                  return GestureDetector(
                                    onTap: kantin != null
                                        ? () => _keKantin(produk, kantin)
                                        : null,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center, // ← tengah
                                        children: [
                                          // Foto produk — rata tengah
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: fotoUrl != null
                                                ? Image.network(
                                                    fotoUrl,
                                                    width: 64,
                                                    height: 64,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, __, ___) => _placeholderImage(),
                                                  )
                                                : _placeholderImage(),
                                          ),
                                          const SizedBox(width: 12),

                                          // Info produk
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if (kantin != null)
                                                  Row(
                                                    children: [
                                                      Icon(Icons.storefront, size: 14, color: Warna.warnaTextGray),
                                                      const SizedBox(width: 4),
                                                      Expanded(
                                                        child: Text(
                                                          kantin['nama_kantin'] ?? '',
                                                          style: TextStyle(fontSize: 12, color: Warna.warnaTextGray),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  produk['nama_produk'] ?? '',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _formatRupiah(produk['harga_produk']),
                                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '$jumlahFavorit favorit',
                                                  style: TextStyle(fontSize: 12, color: Warna.warnaAccent),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Tombol hapus favorit — rata tengah
                                          IconButton(
                                            icon: const Icon(Icons.favorite, color: Colors.red),
                                            onPressed: () => _hapusFavorit(favoritId),
                                            tooltip: 'Hapus dari favorit',
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return PalangTamu(text: 'Silahkan login untuk dapat melihat produk favorit anda',);
        }
      }
    );
    
  }

  Widget _placeholderImage() {
    return Container(
      width: 64,
      height: 64,
      color: Colors.grey[300],
      child: const Icon(Icons.fastfood, color: Colors.grey),
    );
  }
}