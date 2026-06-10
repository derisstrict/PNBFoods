import 'package:hive/hive.dart';
import 'package:pnbfoods/models/item_keranjang.dart';

class CartService {
  static final CartService _instance = CartService._();
  factory CartService() => _instance;
  CartService._();

  late Box _box;

  Box get box => _box;

  Future<void> init() async {
    _box = await Hive.openBox('cart');
  }

  void addOrUpdate(int produkId, String nama, int harga, String imageUrl, int jumlah) {
    _box.put(produkId, {
      'nama': nama,
      'harga': harga,
      'imageUrl': imageUrl,
      'jumlah': jumlah,
      'produk_id': produkId,
    });
  }

  int getQuantity(int produkId) {
    final item = _box.get(produkId);
    if (item == null) return 0;
    return (item as Map)['jumlah'] as int;
  }

  void removeItem(int produkId) {
    _box.delete(produkId);
  }

  List<ItemKeranjang> getAllItems() {
    return _box.keys.map((key) {
      final data = _box.get(key) as Map;
      return ItemKeranjang(
        nama: data['nama'] as String,
        harga: data['harga'] as int,
        imageUrl: data['imageUrl'] as String,
        jumlah: data['jumlah'] as int,
        produkId: data['produk_id'] as int?,
      );
    }).toList();
  }

  int get totalItems => getAllItems().fold(0, (sum, item) => sum + item.jumlah);

  int get totalHarga => getAllItems().fold(0, (sum, item) => sum + item.subtotal);

  bool get isEmpty => _box.isEmpty;

  void clear() => _box.clear();
}
