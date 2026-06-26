class DetailOrderan {
  final int id;
  final int jumlah;
  final String? catatan;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DetailOrderan({
    required this.id,
    required this.jumlah,
    this.catatan,
    this.createdAt,
    this.updatedAt,
  });

  factory DetailOrderan.fromJson(Map<String, dynamic> json) {
    return DetailOrderan(
      id: json['id'] as int,
      jumlah: json['jumlah'] as int,
      catatan: json['catatan'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
