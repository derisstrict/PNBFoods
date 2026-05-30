// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProdukTable extends Produk with TableInfo<$ProdukTable, ProdukData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProdukTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fotoProdukMeta = const VerificationMeta(
    'fotoProduk',
  );
  @override
  late final GeneratedColumn<String> fotoProduk = GeneratedColumn<String>(
    'foto_produk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stokMeta = const VerificationMeta('stok');
  @override
  late final GeneratedColumn<String> stok = GeneratedColumn<String>(
    'stok',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deskripsiProdukMeta = const VerificationMeta(
    'deskripsiProduk',
  );
  @override
  late final GeneratedColumn<String> deskripsiProduk = GeneratedColumn<String>(
    'deskripsi_produk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kategoriProdukMeta = const VerificationMeta(
    'kategoriProduk',
  );
  @override
  late final GeneratedColumn<String> kategoriProduk = GeneratedColumn<String>(
    'kategori_produk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaProdukMeta = const VerificationMeta(
    'hargaProduk',
  );
  @override
  late final GeneratedColumn<String> hargaProduk = GeneratedColumn<String>(
    'harga_produk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaProdukMeta = const VerificationMeta(
    'namaProduk',
  );
  @override
  late final GeneratedColumn<String> namaProduk = GeneratedColumn<String>(
    'nama_produk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fotoProduk,
    stok,
    deskripsiProduk,
    kategoriProduk,
    hargaProduk,
    namaProduk,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produk';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProdukData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('foto_produk')) {
      context.handle(
        _fotoProdukMeta,
        fotoProduk.isAcceptableOrUnknown(data['foto_produk']!, _fotoProdukMeta),
      );
    } else if (isInserting) {
      context.missing(_fotoProdukMeta);
    }
    if (data.containsKey('stok')) {
      context.handle(
        _stokMeta,
        stok.isAcceptableOrUnknown(data['stok']!, _stokMeta),
      );
    } else if (isInserting) {
      context.missing(_stokMeta);
    }
    if (data.containsKey('deskripsi_produk')) {
      context.handle(
        _deskripsiProdukMeta,
        deskripsiProduk.isAcceptableOrUnknown(
          data['deskripsi_produk']!,
          _deskripsiProdukMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deskripsiProdukMeta);
    }
    if (data.containsKey('kategori_produk')) {
      context.handle(
        _kategoriProdukMeta,
        kategoriProduk.isAcceptableOrUnknown(
          data['kategori_produk']!,
          _kategoriProdukMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kategoriProdukMeta);
    }
    if (data.containsKey('harga_produk')) {
      context.handle(
        _hargaProdukMeta,
        hargaProduk.isAcceptableOrUnknown(
          data['harga_produk']!,
          _hargaProdukMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hargaProdukMeta);
    }
    if (data.containsKey('nama_produk')) {
      context.handle(
        _namaProdukMeta,
        namaProduk.isAcceptableOrUnknown(data['nama_produk']!, _namaProdukMeta),
      );
    } else if (isInserting) {
      context.missing(_namaProdukMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProdukData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProdukData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fotoProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto_produk'],
      )!,
      stok: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stok'],
      )!,
      deskripsiProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deskripsi_produk'],
      )!,
      kategoriProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori_produk'],
      )!,
      hargaProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}harga_produk'],
      )!,
      namaProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_produk'],
      )!,
    );
  }

  @override
  $ProdukTable createAlias(String alias) {
    return $ProdukTable(attachedDatabase, alias);
  }
}

class ProdukData extends DataClass implements Insertable<ProdukData> {
  final int id;
  final String fotoProduk;
  final String stok;
  final String deskripsiProduk;
  final String kategoriProduk;
  final String hargaProduk;
  final String namaProduk;
  const ProdukData({
    required this.id,
    required this.fotoProduk,
    required this.stok,
    required this.deskripsiProduk,
    required this.kategoriProduk,
    required this.hargaProduk,
    required this.namaProduk,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['foto_produk'] = Variable<String>(fotoProduk);
    map['stok'] = Variable<String>(stok);
    map['deskripsi_produk'] = Variable<String>(deskripsiProduk);
    map['kategori_produk'] = Variable<String>(kategoriProduk);
    map['harga_produk'] = Variable<String>(hargaProduk);
    map['nama_produk'] = Variable<String>(namaProduk);
    return map;
  }

  ProdukCompanion toCompanion(bool nullToAbsent) {
    return ProdukCompanion(
      id: Value(id),
      fotoProduk: Value(fotoProduk),
      stok: Value(stok),
      deskripsiProduk: Value(deskripsiProduk),
      kategoriProduk: Value(kategoriProduk),
      hargaProduk: Value(hargaProduk),
      namaProduk: Value(namaProduk),
    );
  }

  factory ProdukData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProdukData(
      id: serializer.fromJson<int>(json['id']),
      fotoProduk: serializer.fromJson<String>(json['fotoProduk']),
      stok: serializer.fromJson<String>(json['stok']),
      deskripsiProduk: serializer.fromJson<String>(json['deskripsiProduk']),
      kategoriProduk: serializer.fromJson<String>(json['kategoriProduk']),
      hargaProduk: serializer.fromJson<String>(json['hargaProduk']),
      namaProduk: serializer.fromJson<String>(json['namaProduk']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fotoProduk': serializer.toJson<String>(fotoProduk),
      'stok': serializer.toJson<String>(stok),
      'deskripsiProduk': serializer.toJson<String>(deskripsiProduk),
      'kategoriProduk': serializer.toJson<String>(kategoriProduk),
      'hargaProduk': serializer.toJson<String>(hargaProduk),
      'namaProduk': serializer.toJson<String>(namaProduk),
    };
  }

  ProdukData copyWith({
    int? id,
    String? fotoProduk,
    String? stok,
    String? deskripsiProduk,
    String? kategoriProduk,
    String? hargaProduk,
    String? namaProduk,
  }) => ProdukData(
    id: id ?? this.id,
    fotoProduk: fotoProduk ?? this.fotoProduk,
    stok: stok ?? this.stok,
    deskripsiProduk: deskripsiProduk ?? this.deskripsiProduk,
    kategoriProduk: kategoriProduk ?? this.kategoriProduk,
    hargaProduk: hargaProduk ?? this.hargaProduk,
    namaProduk: namaProduk ?? this.namaProduk,
  );
  ProdukData copyWithCompanion(ProdukCompanion data) {
    return ProdukData(
      id: data.id.present ? data.id.value : this.id,
      fotoProduk: data.fotoProduk.present
          ? data.fotoProduk.value
          : this.fotoProduk,
      stok: data.stok.present ? data.stok.value : this.stok,
      deskripsiProduk: data.deskripsiProduk.present
          ? data.deskripsiProduk.value
          : this.deskripsiProduk,
      kategoriProduk: data.kategoriProduk.present
          ? data.kategoriProduk.value
          : this.kategoriProduk,
      hargaProduk: data.hargaProduk.present
          ? data.hargaProduk.value
          : this.hargaProduk,
      namaProduk: data.namaProduk.present
          ? data.namaProduk.value
          : this.namaProduk,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProdukData(')
          ..write('id: $id, ')
          ..write('fotoProduk: $fotoProduk, ')
          ..write('stok: $stok, ')
          ..write('deskripsiProduk: $deskripsiProduk, ')
          ..write('kategoriProduk: $kategoriProduk, ')
          ..write('hargaProduk: $hargaProduk, ')
          ..write('namaProduk: $namaProduk')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fotoProduk,
    stok,
    deskripsiProduk,
    kategoriProduk,
    hargaProduk,
    namaProduk,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProdukData &&
          other.id == this.id &&
          other.fotoProduk == this.fotoProduk &&
          other.stok == this.stok &&
          other.deskripsiProduk == this.deskripsiProduk &&
          other.kategoriProduk == this.kategoriProduk &&
          other.hargaProduk == this.hargaProduk &&
          other.namaProduk == this.namaProduk);
}

class ProdukCompanion extends UpdateCompanion<ProdukData> {
  final Value<int> id;
  final Value<String> fotoProduk;
  final Value<String> stok;
  final Value<String> deskripsiProduk;
  final Value<String> kategoriProduk;
  final Value<String> hargaProduk;
  final Value<String> namaProduk;
  const ProdukCompanion({
    this.id = const Value.absent(),
    this.fotoProduk = const Value.absent(),
    this.stok = const Value.absent(),
    this.deskripsiProduk = const Value.absent(),
    this.kategoriProduk = const Value.absent(),
    this.hargaProduk = const Value.absent(),
    this.namaProduk = const Value.absent(),
  });
  ProdukCompanion.insert({
    this.id = const Value.absent(),
    required String fotoProduk,
    required String stok,
    required String deskripsiProduk,
    required String kategoriProduk,
    required String hargaProduk,
    required String namaProduk,
  }) : fotoProduk = Value(fotoProduk),
       stok = Value(stok),
       deskripsiProduk = Value(deskripsiProduk),
       kategoriProduk = Value(kategoriProduk),
       hargaProduk = Value(hargaProduk),
       namaProduk = Value(namaProduk);
  static Insertable<ProdukData> custom({
    Expression<int>? id,
    Expression<String>? fotoProduk,
    Expression<String>? stok,
    Expression<String>? deskripsiProduk,
    Expression<String>? kategoriProduk,
    Expression<String>? hargaProduk,
    Expression<String>? namaProduk,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fotoProduk != null) 'foto_produk': fotoProduk,
      if (stok != null) 'stok': stok,
      if (deskripsiProduk != null) 'deskripsi_produk': deskripsiProduk,
      if (kategoriProduk != null) 'kategori_produk': kategoriProduk,
      if (hargaProduk != null) 'harga_produk': hargaProduk,
      if (namaProduk != null) 'nama_produk': namaProduk,
    });
  }

  ProdukCompanion copyWith({
    Value<int>? id,
    Value<String>? fotoProduk,
    Value<String>? stok,
    Value<String>? deskripsiProduk,
    Value<String>? kategoriProduk,
    Value<String>? hargaProduk,
    Value<String>? namaProduk,
  }) {
    return ProdukCompanion(
      id: id ?? this.id,
      fotoProduk: fotoProduk ?? this.fotoProduk,
      stok: stok ?? this.stok,
      deskripsiProduk: deskripsiProduk ?? this.deskripsiProduk,
      kategoriProduk: kategoriProduk ?? this.kategoriProduk,
      hargaProduk: hargaProduk ?? this.hargaProduk,
      namaProduk: namaProduk ?? this.namaProduk,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fotoProduk.present) {
      map['foto_produk'] = Variable<String>(fotoProduk.value);
    }
    if (stok.present) {
      map['stok'] = Variable<String>(stok.value);
    }
    if (deskripsiProduk.present) {
      map['deskripsi_produk'] = Variable<String>(deskripsiProduk.value);
    }
    if (kategoriProduk.present) {
      map['kategori_produk'] = Variable<String>(kategoriProduk.value);
    }
    if (hargaProduk.present) {
      map['harga_produk'] = Variable<String>(hargaProduk.value);
    }
    if (namaProduk.present) {
      map['nama_produk'] = Variable<String>(namaProduk.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProdukCompanion(')
          ..write('id: $id, ')
          ..write('fotoProduk: $fotoProduk, ')
          ..write('stok: $stok, ')
          ..write('deskripsiProduk: $deskripsiProduk, ')
          ..write('kategoriProduk: $kategoriProduk, ')
          ..write('hargaProduk: $hargaProduk, ')
          ..write('namaProduk: $namaProduk')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProdukTable produk = $ProdukTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [produk];
}

typedef $$ProdukTableCreateCompanionBuilder =
    ProdukCompanion Function({
      Value<int> id,
      required String fotoProduk,
      required String stok,
      required String deskripsiProduk,
      required String kategoriProduk,
      required String hargaProduk,
      required String namaProduk,
    });
typedef $$ProdukTableUpdateCompanionBuilder =
    ProdukCompanion Function({
      Value<int> id,
      Value<String> fotoProduk,
      Value<String> stok,
      Value<String> deskripsiProduk,
      Value<String> kategoriProduk,
      Value<String> hargaProduk,
      Value<String> namaProduk,
    });

class $$ProdukTableFilterComposer
    extends Composer<_$AppDatabase, $ProdukTable> {
  $$ProdukTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fotoProduk => $composableBuilder(
    column: $table.fotoProduk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stok => $composableBuilder(
    column: $table.stok,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deskripsiProduk => $composableBuilder(
    column: $table.deskripsiProduk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kategoriProduk => $composableBuilder(
    column: $table.kategoriProduk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hargaProduk => $composableBuilder(
    column: $table.hargaProduk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProdukTableOrderingComposer
    extends Composer<_$AppDatabase, $ProdukTable> {
  $$ProdukTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fotoProduk => $composableBuilder(
    column: $table.fotoProduk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stok => $composableBuilder(
    column: $table.stok,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deskripsiProduk => $composableBuilder(
    column: $table.deskripsiProduk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kategoriProduk => $composableBuilder(
    column: $table.kategoriProduk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hargaProduk => $composableBuilder(
    column: $table.hargaProduk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProdukTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProdukTable> {
  $$ProdukTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fotoProduk => $composableBuilder(
    column: $table.fotoProduk,
    builder: (column) => column,
  );

  GeneratedColumn<String> get stok =>
      $composableBuilder(column: $table.stok, builder: (column) => column);

  GeneratedColumn<String> get deskripsiProduk => $composableBuilder(
    column: $table.deskripsiProduk,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kategoriProduk => $composableBuilder(
    column: $table.kategoriProduk,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hargaProduk => $composableBuilder(
    column: $table.hargaProduk,
    builder: (column) => column,
  );

  GeneratedColumn<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => column,
  );
}

class $$ProdukTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProdukTable,
          ProdukData,
          $$ProdukTableFilterComposer,
          $$ProdukTableOrderingComposer,
          $$ProdukTableAnnotationComposer,
          $$ProdukTableCreateCompanionBuilder,
          $$ProdukTableUpdateCompanionBuilder,
          (ProdukData, BaseReferences<_$AppDatabase, $ProdukTable, ProdukData>),
          ProdukData,
          PrefetchHooks Function()
        > {
  $$ProdukTableTableManager(_$AppDatabase db, $ProdukTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProdukTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProdukTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProdukTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fotoProduk = const Value.absent(),
                Value<String> stok = const Value.absent(),
                Value<String> deskripsiProduk = const Value.absent(),
                Value<String> kategoriProduk = const Value.absent(),
                Value<String> hargaProduk = const Value.absent(),
                Value<String> namaProduk = const Value.absent(),
              }) => ProdukCompanion(
                id: id,
                fotoProduk: fotoProduk,
                stok: stok,
                deskripsiProduk: deskripsiProduk,
                kategoriProduk: kategoriProduk,
                hargaProduk: hargaProduk,
                namaProduk: namaProduk,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fotoProduk,
                required String stok,
                required String deskripsiProduk,
                required String kategoriProduk,
                required String hargaProduk,
                required String namaProduk,
              }) => ProdukCompanion.insert(
                id: id,
                fotoProduk: fotoProduk,
                stok: stok,
                deskripsiProduk: deskripsiProduk,
                kategoriProduk: kategoriProduk,
                hargaProduk: hargaProduk,
                namaProduk: namaProduk,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProdukTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProdukTable,
      ProdukData,
      $$ProdukTableFilterComposer,
      $$ProdukTableOrderingComposer,
      $$ProdukTableAnnotationComposer,
      $$ProdukTableCreateCompanionBuilder,
      $$ProdukTableUpdateCompanionBuilder,
      (ProdukData, BaseReferences<_$AppDatabase, $ProdukTable, ProdukData>),
      ProdukData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProdukTableTableManager get produk =>
      $$ProdukTableTableManager(_db, _db.produk);
}
