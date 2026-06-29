class Orderan {
  final int id;
  final String statusOrderan;
  final double totalHarga;
  final DateTime tanggalOrderan;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int pelangganId;
  final String? namaPelanggan;
  final String? nim;
  final String? fotoProfile;
  final String? fotoUrl;
  final String? statusPembayaran;
  final Map<String, dynamic>? kantin;
  final List<dynamic> items;

  const Orderan({
    required this.id,
    required this.statusOrderan,
    required this.totalHarga,
    required this.tanggalOrderan,
    required this.pelangganId,
    this.namaPelanggan,
    this.nim,
    this.fotoProfile,
    this.fotoUrl,
    this.createdAt,
    this.updatedAt,
    this.statusPembayaran,
    this.kantin,
    required this.items,
  });

  factory Orderan.fromJson(Map<String, dynamic> json) {
    return Orderan(
      id: json['id'] as int,
      statusOrderan: json['status_orderan'] as String,
      totalHarga: (json['total_harga'] as num).toDouble(),
      tanggalOrderan: DateTime.parse(json['tanggal_orderan'] as String),
      pelangganId: json['pelanggan_id'],
      namaPelanggan: json['pelanggan']?['nama'] as String?,
      nim: json['pelanggan']?['nim'] as String?,
      fotoProfile: json['pelanggan']?['foto_profile'] as String?,
      fotoUrl: json['pelanggan']?['foto_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      statusPembayaran: json['pembayaran']?['status_pembayaran'],
      kantin: json['kantin'] as Map<String, dynamic>?,
      items:
          (json['detail_orderan'] as List<dynamic>?)
              ?.map(
                (e) => {
                  'jumlah': e['jumlah'],
                  'nama_produk': e['produk']?['nama_produk'] ?? '',
                  'harga_subtotal': e['subtotal'] ?? 0,
                },
              )
              .toList() ??
          [],
    );
  }
}
