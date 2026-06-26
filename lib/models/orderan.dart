class Orderan {
  final int id;
  final String statusOrderan;
  final double totalHarga;
  final DateTime tanggalOrderan;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int pelangganId;

  const Orderan({
    required this.id,
    required this.statusOrderan,
    required this.totalHarga,
    required this.tanggalOrderan,
    required this.pelangganId,
    this.createdAt,
    this.updatedAt,
  });

  factory Orderan.fromJson(Map<String, dynamic> json) {
    return Orderan(
      id: json['id'] as int,
      statusOrderan: json['status_orderan'] as String,
      totalHarga: (json['total_harga'] as num).toDouble(),
      tanggalOrderan: DateTime.parse(json['tanggal_orderan'] as String),
      pelangganId: json['pelanggan_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
