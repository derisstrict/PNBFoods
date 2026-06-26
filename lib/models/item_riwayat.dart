//*Model riwayat dari API
class ItemRiwayat {
  final int id;
  final String nama;
  final int jumlah;
  final int subtotal;

  const ItemRiwayat({
    required this.id,
    required this.nama,
    required this.jumlah,
    required this.subtotal,
  });

  factory ItemRiwayat.fromJson(Map<String, dynamic> json) {
    final produk = json['produk'];
    return ItemRiwayat(
      id: json['id'] as int,
      nama: produk != null ? produk['nama_produk'] as String : 'Produk dihapus',
      jumlah: json['jumlah'] as int,
      subtotal: (json['subtotal'] as num).toInt(),
    );
  }
}

class TransaksiRiwayat {
  final int id;
  final String namaKantin;
  final String kategoriKantin;
  final String? imageUrl;
  final DateTime tanggalOrderan;
  final int totalHarga;
  final String? metodePembayaran;
  final String? statusPembayaran;
  final List<ItemRiwayat> items;

  const TransaksiRiwayat({
    required this.id,
    required this.namaKantin,
    required this.kategoriKantin,
    required this.imageUrl,
    required this.tanggalOrderan,
    required this.totalHarga,
    required this.metodePembayaran,
    required this.statusPembayaran,
    required this.items,
  });

  int get totalItem => items.fold(0, (sum, item) => sum + item.jumlah);

  //*Format jam, misal "12.38 PM"
  String get jam {
    final hour = tanggalOrderan.hour;
    final minute = tanggalOrderan.minute.toString().padLeft(2, '0');
    final isPM = hour >= 12;
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '${hour12.toString().padLeft(2, '0')}.$minute ${isPM ? 'PM' : 'AM'}';
  }

  factory TransaksiRiwayat.fromJson(Map<String, dynamic> json) {
    final kantin = json['kantin'];
    final pembayaran = json['pembayaran'];
    final detailList = (json['detail_orderan'] as List<dynamic>? ?? [])
        .map((item) => ItemRiwayat.fromJson(item as Map<String, dynamic>))
        .toList();

    return TransaksiRiwayat(
      id: json['id'] as int,
      namaKantin: kantin != null ? kantin['nama_kantin'] as String : 'Kantin tidak diketahui',
      kategoriKantin: kantin != null ? kantin['kategori'] as String : '-',
      imageUrl: kantin != null ? kantin['foto_url'] as String? : null,
      tanggalOrderan: DateTime.parse(json['tanggal_orderan'] as String),
      totalHarga: (json['total_harga'] as num).toInt(),
      metodePembayaran: pembayaran != null ? pembayaran['metode_pembayaran'] as String? : null,
      statusPembayaran: pembayaran != null ? pembayaran['status_pembayaran'] as String? : null,
      items: detailList,
    );
  }
}

//*Mengelompokkan transaksi berdasarkan tanggal (untuk ditampilkan per section)
class RiwayatPerTanggal {
  final String tanggal; // contoh: "30 April 2026"
  final List<TransaksiRiwayat> transaksi;

  const RiwayatPerTanggal({
    required this.tanggal,
    required this.transaksi,
  });
}

//*Helper: kelompokkan List<TransaksiRiwayat> jadi List<RiwayatPerTanggal>
List<RiwayatPerTanggal> kelompokkanRiwayatPerTanggal(List<TransaksiRiwayat> semuaTransaksi) {
  final Map<String, List<TransaksiRiwayat>> grouped = {};

  const namaBulan = [
    '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  for (var transaksi in semuaTransaksi) {
    final tgl = transaksi.tanggalOrderan;
    final key = '${tgl.day} ${namaBulan[tgl.month]} ${tgl.year}';
    grouped.putIfAbsent(key, () => []).add(transaksi);
  }

  return grouped.entries
      .map((entry) => RiwayatPerTanggal(tanggal: entry.key, transaksi: entry.value))
      .toList();
}