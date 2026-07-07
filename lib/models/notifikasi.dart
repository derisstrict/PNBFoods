class NotifikasiModel {
  final int id;
  final int? orderanId;
  final String judul;
  final String isi;
  final bool isRead;
  final String? kantinNama;
  final DateTime? createdAt;

  const NotifikasiModel({
    required this.id,
    this.orderanId,
    required this.judul,
    required this.isi,
    required this.isRead,
    this.kantinNama,
    this.createdAt,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id: json['id'] as int,
      orderanId: json['orderan_id'] as int?,
      judul: json['judul'] as String,
      isi: json['isi'] as String,
      isRead: json['is_read'] as bool,
      kantinNama: json['kantin_nama'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}
