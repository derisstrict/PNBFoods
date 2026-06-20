class Pembayaran {
  final int id;
  final String metodePembayaran;
  final double totalPembayaran;
  final String statusPembayaran;
  final String? snapToken;
  final String? snapRedirectUrl;
  final String? qrImageUrl;
  final String? midtransTransactionStatus;
  final DateTime? expiredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Pembayaran({
    required this.id,
    required this.metodePembayaran,
    required this.totalPembayaran,
    required this.statusPembayaran,
    this.snapToken,
    this.snapRedirectUrl,
    this.qrImageUrl,
    this.midtransTransactionStatus,
    this.expiredAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Pembayaran.fromJson(Map<String, dynamic> json) {
    return Pembayaran(
      id: json['id'] as int,
      metodePembayaran: json['metode_pembayaran'] as String,
      totalPembayaran: (json['total_pembayaran'] as num).toDouble(),
      statusPembayaran: json['status_pembayaran'] as String,
      snapToken: json['snap_token'] as String?,
      snapRedirectUrl: json['snap_redirect_url'] as String?,
      qrImageUrl: json['qr_image_url'] as String?,
      midtransTransactionStatus:
          json['midtrans_transaction_status'] as String?,
      expiredAt: json['expired_at'] != null
          ? DateTime.parse(json['expired_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  bool get isLunas => statusPembayaran == 'lunas';
  bool get isMenunggu => statusPembayaran == 'menunggu_pembayaran';
  bool get isTerminal =>
      statusPembayaran == 'lunas' ||
      statusPembayaran == 'gagal' ||
      statusPembayaran == 'dibatalkan' ||
      statusPembayaran == 'kadaluwarsa';
}
