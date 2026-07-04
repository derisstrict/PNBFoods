class Penjual {
  final int idPenjual;
  final String namaPenjual;
  final String email;
  final String? fotoProfile;
  final String? password;
  final String? fotoUrl;
  final String? saldo;

  const Penjual({
    required this.idPenjual,
    required this.namaPenjual,
    required this.email,
    this.fotoProfile,
    this.password,
    this.fotoUrl,
    this.saldo,
  });

  factory Penjual.fromJson(Map<String, dynamic> json) {
    return Penjual(
      idPenjual: json['id'] as int,
      namaPenjual: json['nama'] as String,
      email: json['email'] as String,
      fotoProfile: json['foto_profile'] as String?,
      password: json['password'] as String?,
      fotoUrl: json['foto_url'] as String?,
      saldo: json['saldo'] as String?,
    );
  }
}