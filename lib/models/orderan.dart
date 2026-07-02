import 'package:intl/intl.dart';

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
                  'catatan': e['catatan'] ?? '',
                },
              )
              .toList() ??
          [],
    );
  }

  Orderan copyWith({
    int? id,
    String? statusOrderan,
    double? totalHarga,
    DateTime? tanggalOrderan,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? pelangganId,
    String? namaPelanggan,
    String? nim,
    String? fotoProfile,
    String? fotoUrl,
    String? statusPembayaran,
    Map<String, dynamic>? kantin,
    List<dynamic>? items,
  }) {
    return Orderan(
      id: id ?? this.id,
      statusOrderan: statusOrderan ?? this.statusOrderan,
      totalHarga: totalHarga ?? this.totalHarga,
      tanggalOrderan: tanggalOrderan ?? this.tanggalOrderan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pelangganId: pelangganId ?? this.pelangganId,
      namaPelanggan: namaPelanggan ?? this.namaPelanggan,
      nim: nim ?? this.nim,
      fotoProfile: fotoProfile ?? this.fotoProfile,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      statusPembayaran: statusPembayaran ?? this.statusPembayaran,
      kantin: kantin ?? this.kantin,
      items: items ?? this.items,
    );
  }

  static Map<String, List<Orderan>> orderanPertanggal(List<Orderan> list) {
    final Map<String, List<Orderan>> dataTerkelompok = {};
    for (var orderan in list) {
      String keyTanggal = DateFormat(
        'yyyy-MM-dd',
      ).format(orderan.tanggalOrderan);
      if (!dataTerkelompok.containsKey(keyTanggal)) {
        dataTerkelompok[keyTanggal] = [];
      }
      dataTerkelompok[keyTanggal]!.add(orderan);
    }
    return dataTerkelompok;
  }
}
