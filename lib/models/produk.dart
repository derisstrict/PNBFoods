class Produk {
  final int id;
  final String namaProduk;
  final String? fotoProduk;
  final String? fotoUrl;
  final String? deskripsiProduk;
  final String kategoriProduk;
  final int hargaProduk;
  final int stok;

  const Produk({required this.id, required this.namaProduk, required this.fotoProduk, required this.fotoUrl, required this.deskripsiProduk, required this.kategoriProduk, required this.hargaProduk, required this.stok});

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'] as int,
      namaProduk: json['nama_produk'] as String,
      fotoProduk: json['foto_produk'] as String?,
      fotoUrl: json['foto_url'] as String?,
      deskripsiProduk: json['deskripsi_produk'] as String?,
      kategoriProduk: json['kategori_produk'] as String,
      hargaProduk: json['harga_produk'] as int,
      stok: json['stok'] as int,
    );
  }
}
