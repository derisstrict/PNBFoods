import 'package:hive/hive.dart';
import 'package:pnbfoods/models/item_keranjang.dart';

class CartService {
  static final CartService _instance = CartService._();
  factory CartService() => _instance;
  CartService._();

  late Box _box;

  Box get box => _box;

  String _key(int kantinId, int produkId) => '$kantinId:$produkId';

  bool _isValidKey(dynamic key) => key is String;

  Future<void> init() async {
    _box = await Hive.openBox('cart');
  }

  void addOrUpdate(int kantinId, int produkId, String nama, int harga, String imageUrl, int jumlah, int stok, {String? catatan}) {
    _box.put(_key(kantinId, produkId), {
      'nama': nama,
      'harga': harga,
      'imageUrl': imageUrl,
      'jumlah': jumlah,
      'stok': stok,
      'produk_id': produkId,
      'kantin_id': kantinId,
      'catatan': catatan ?? '',
    });
  }

  int getQuantity(int kantinId, int produkId) {
    final k = _key(kantinId, produkId);
    if (!_box.containsKey(k)) return 0;
    final item = _box.get(k) as Map;
    return item['jumlah'] as int;
  }

  void removeItem(int kantinId, int produkId) {
    _box.delete(_key(kantinId, produkId));
  }

  List<ItemKeranjang> getAllItems({int? kantinId}) {
    return _box.keys.where(_isValidKey).where((key) {
      if (kantinId == null) return true;
      return (key as String).startsWith('$kantinId:');
    }).map((key) {
      final data = _box.get(key) as Map;
      return ItemKeranjang(
        nama: data['nama'] as String,
        harga: data['harga'] as int,
        imageUrl: data['imageUrl'] as String,
        jumlah: data['jumlah'] as int,
        stok: data['stok'] as int,
        produkId: data['produk_id'] as int?,
        catatan: data['catatan'] as String?,
      );
    }).toList();
  }

  int totalItems({int? kantinId}) {
    return getAllItems(kantinId: kantinId).fold(0, (sum, item) => sum + item.jumlah);
  }

  int totalHarga({int? kantinId}) {
    return getAllItems(kantinId: kantinId).fold(0, (sum, item) => sum + item.subtotal);
  }

  bool isEmpty({int? kantinId}) {
    if (kantinId == null) return _box.isEmpty;
    return !_box.keys.where(_isValidKey).any((key) => (key as String).startsWith('$kantinId:'));
  }

  void clear({int? kantinId}) {
    if (kantinId != null) {
      final keysToRemove = _box.keys.where(_isValidKey).where((key) => (key as String).startsWith('$kantinId:')).toList();
      _box.deleteAll(keysToRemove);
    } else {
      _box.clear();
    }
  }
}
