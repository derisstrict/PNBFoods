// Model dummy untuk item dalam satu transaksi
class ItemRiwayat {
  final String nama;
  final int jumlah;
  final int subtotal;

  const ItemRiwayat({
    required this.nama,
    required this.jumlah,
    required this.subtotal,
  });
}

// Model dummy untuk satu transaksi riwayat
class TransaksiRiwayat {
  final String namaKantin;
  final String kategoriKantin;
  final String imageUrl;
  final String jam;
  final int totalHarga;
  final List<ItemRiwayat> items;

  const TransaksiRiwayat({
    required this.namaKantin,
    required this.kategoriKantin,
    required this.imageUrl,
    required this.jam,
    required this.totalHarga,
    required this.items,
  });

  int get totalItem => items.fold(0, (sum, item) => sum + item.jumlah);
}

// Model dummy untuk satu tanggal yang berisi beberapa transaksi
class RiwayatPerTanggal {
  final String tanggal;
  final List<TransaksiRiwayat> transaksi;

  const RiwayatPerTanggal({
    required this.tanggal,
    required this.transaksi,
  });
}

// ======= DATA DUMMY =======
final List<RiwayatPerTanggal> dummyRiwayat = [
  RiwayatPerTanggal(
    tanggal: '30 April 2026',
    transaksi: [
      TransaksiRiwayat(
        namaKantin: 'Kantin Ibu Gacor',
        kategoriKantin: 'Makanan & Minuman',
        imageUrl: 'https://picsum.photos/100?kantin=1',
        jam: '12.38 PM',
        totalHarga: 68000,
        items: const [
          ItemRiwayat(nama: 'Nasi Goreng Spesial', jumlah: 2, subtotal: 50000),
          ItemRiwayat(nama: 'Tipat Cantok', jumlah: 1, subtotal: 18000),
        ],
      ),
      TransaksiRiwayat(
        namaKantin: 'Kantin Ibu Gacor',
        kategoriKantin: 'Makanan & Minuman',
        imageUrl: 'https://picsum.photos/100?kantin=1',
        jam: '11.21 PM',
        totalHarga: 18000,
        items: const [
          ItemRiwayat(nama: 'Nasi Pecel', jumlah: 1, subtotal: 18000),
        ],
      ),
    ],
  ),
];