import 'package:flutter/material.dart';
import 'package:pnbfoods/models/produk.dart';
import 'package:pnbfoods/common/warna.dart';

// Wrapper sementara untuk data tambahan yang belum ada di model Produk
// (kantin, jumlah favorit). Sesuaikan/ganti kalau API favorit sudah jadi.
class FavoritItem {
  final Produk produk;
  final String kantin;
  final int jumlahFavorit;

  FavoritItem({
    required this.produk,
    required this.kantin,
    required this.jumlahFavorit,
  });
}

class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  // Data dummy
  final List<FavoritItem> _favoritList = [
    FavoritItem(
      produk: const Produk(
        id: 1,
        namaProduk: 'Nasi Goreng Spesial',
        fotoProduk: null,
        fotoUrl:
            'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=200',
        deskripsiProduk: null,
        kategoriProduk: 'Makanan',
        hargaProduk: 25000,
        stok: 10,
      ),
      kantin: 'Kantin Bu Gacor',
      jumlahFavorit: 250,
    ),
    FavoritItem(
      produk: const Produk(
        id: 2,
        namaProduk: 'Tipat Cantok',
        fotoProduk: null,
        fotoUrl:
            'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=200',
        deskripsiProduk: null,
        kategoriProduk: 'Makanan',
        hargaProduk: 18000,
        stok: 10,
      ),
      kantin: 'Kantin Bu Gacor',
      jumlahFavorit: 131,
    ),
  ];

  String _formatRupiah(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) buffer.write('.');
    }
    return 'Rp. ${buffer.toString().split('').reversed.join()}';
  }

  void _hapusFavorit(int index) {
    setState(() {
      _favoritList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  Icon(Icons.favorite_border, color: Colors.white),
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

            // Jumlah item
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_favoritList.length} Item',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // List favorit
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _favoritList.length,
                itemBuilder: (context, index) {
                  final item = _favoritList[index];
                  final produk = item.produk;
                  return Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: produk.fotoUrl != null
                              ? Image.network(
                                  produk.fotoUrl!,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 64,
                                    height: 64,
                                    color: Colors.grey[300],
                                    child:
                                        const Icon(Icons.image_not_supported),
                                  ),
                                )
                              : Container(
                                  width: 64,
                                  height: 64,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.fastfood),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.storefront,
                                      size: 14,
                                      color: Warna.warnaTextGray),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.kantin,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Warna.warnaTextGray,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                produk.namaProduk,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatRupiah(produk.hargaProduk),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.jumlahFavorit} favorit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Warna.warnaAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => _hapusFavorit(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Button Kembali
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Warna.warnaAccent,
        unselectedItemColor: Warna.warnaTextGray,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}