//*Model dummy ItemKeranjang
class ItemKeranjang {
  final String nama;
  final int harga;
  final String imageUrl;
  int jumlah;

  ItemKeranjang({
    required this.nama,
    required this.harga,
    required this.imageUrl,
    required this.jumlah,
  });

  int get subtotal => harga * jumlah;
}

// Data dummy
final List<ItemKeranjang> dummyKeranjang = [
  ItemKeranjang(
    nama: 'Mie Ayam',
    harga: 25000,
    imageUrl: 'https://picsum.photos/200?food=1',
    jumlah: 2,
  ),
  ItemKeranjang(
    nama: 'Tipat Cantok',
    harga: 18000,
    imageUrl: 'https://picsum.photos/200?food=2',
    jumlah: 1,
  ),
];