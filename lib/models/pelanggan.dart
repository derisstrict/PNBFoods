class Pelanggan {
  final int idPelanggan;
  final String namaPelanggan;
  final String nim;
  final String? fotoProfile;
  final String? password;
  final String? fotoUrl;

  const Pelanggan({
    required this.idPelanggan,
    required this.namaPelanggan,
    required this.nim,
    this.fotoProfile,
    this.password,
    this.fotoUrl
  });

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      idPelanggan: json['id'] as int,
      namaPelanggan: json['nama'] as String,
      nim: json['nim'] as String,
      fotoProfile: json['foto_profile'] as String?,
      password: json['password'] as String?,
      fotoUrl: json['foto_url'] as String?
    );
  }
}