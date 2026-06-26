class Kantin {
  final int id;
  final String namaKantin;
  final String? fotoKantin;
  final String? fotoUrl;
  final String kategori;
  final int idPenjual;

  const Kantin({
    required this.id,
    required this.namaKantin,
    required this.fotoKantin,
    required this.fotoUrl,
    required this.kategori,
    required this.idPenjual,
  });

  factory Kantin.fromJson(Map<String, dynamic> json) {
    return Kantin(
      id: json['id'] is int 
          ? json['id'] as int 
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      namaKantin: json['nama_kantin'] as String,
      fotoKantin: json['foto_kantin'] as String?,
      fotoUrl: json['foto_url'] as String?,
      kategori: json['kategori'] as String,
      idPenjual: json['penjual_id'] is int 
          ? json['penjual_id'] as int 
          : int.tryParse(json['penjual_id']?.toString() ?? '') ?? 0,
    );
  }
}
