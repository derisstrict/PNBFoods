import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Produk extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fotoProduk => text()();
  IntColumn get stok => integer()();
  TextColumn get deskripsiProduk => text()();
  TextColumn get kategoriProduk => text()();
  TextColumn get hargaProduk => text()();
  TextColumn get namaProduk => text()();
}

@DriftDatabase(tables: [Produk])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<ProdukData>> get semuaProduk => select(produk).watch();

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'database',
      native: DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory
      )
    );
  }
}