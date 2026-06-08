class Favorit {
  final int id;
  final int pelangganId;
  final int produkId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Favorit({
    required this.id,
    required this.pelangganId,
    required this.produkId,
    this.createdAt,
    this.updatedAt,
  });

  factory Favorit.fromJson(Map<String, dynamic> json) {
    return Favorit(
      id: json['id'] as int,
      pelangganId: json['pelanggan_id'] as int,
      produkId: json['produk_id'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
