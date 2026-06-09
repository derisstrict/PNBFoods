class Kantin {
  final int id;
  final String namaKantin;
  final String? fotoKantin;
  final String? fotoUrl;
  final String kategori;

  const Kantin({
    required this.id,
    required this.namaKantin,
    required this.fotoKantin,
    required this.fotoUrl,
    required this.kategori,
  });

  factory Kantin.fromJson(Map<String, dynamic> json) {
    return Kantin(
      id: json['id'] as int,
      namaKantin: json['nama_kantin'] as String,
      fotoKantin: json['foto_kantin'] as String?,
      fotoUrl: json['foto_url'] as String?,
      kategori: json['kategori'] as String,
    );
  }
}
