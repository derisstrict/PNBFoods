// class Keranjang {
//   final int id;
//   final int produkId;
//   final String nama;
//   final int harga;
//   final String? fotoUrl;
//   int jumlah;

//   const Keranjang({
//     required this.id,
//     required this.produkId,
//     required this.nama,
//     required this.harga,
//     this.fotoUrl,
//     required this.jumlah,
//   });

//   factory Keranjang.fromJson(Map<String, dynamic> json) {
//     return Keranjang(
//       id: json['id'] as int,
//       produkId: json['produk_id'] as int,
//       nama: json['nama_produk'] as String,
//       harga: json['harga_produk'] as int,
//       fotoUrl: json['foto_url'] as String?,
//       jumlah: json['jumlah'] as int,
//     );
//   }

//   int get subtotal => harga * jumlah;
// }