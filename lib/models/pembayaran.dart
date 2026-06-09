class Pembayaran {
  final int id;
  final String metodePembayaran;
  final double totalPembayaran;
  final String statusPembayaran;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Pembayaran({
    required this.id,
    required this.metodePembayaran,
    required this.totalPembayaran,
    required this.statusPembayaran,
    this.createdAt,
    this.updatedAt,
  });

  factory Pembayaran.fromJson(Map<String, dynamic> json) {
    return Pembayaran(
      id: json['id'] as int,
      metodePembayaran: json['metode_pembayaran'] as String,
      totalPembayaran: (json['total_pembayaran'] as num).toDouble(),
      statusPembayaran: json['status_pembayaran'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
