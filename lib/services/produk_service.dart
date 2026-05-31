import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:pnbfoods/models/produk.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'http://10.0.2.2:8000/api/',
  headers: {'Accept': 'application/json'}
));

Future<Produk> fetchProduk(int id) async {
  final response = await dio.get('produk');

  if (response.statusCode == 200) {
    return Produk.fromJson(response.data['data']);
  } else {
    throw Exception('Gagal mengambil produk');
  }
}

Future<List<Produk>> fetchSemuaProduk() async {
  final response = await dio.get('produk');

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['data'];
    List<Produk> daftarProduk = data.map((item) => Produk.fromJson(item as Map<String, dynamic>)).toList();
    return daftarProduk;
  } else {
    throw Exception('Gagal mengambil produk');
  }
}

Future<void> postProduk({
  required String namaProduk,
  required String deskripsiProduk,
  required int hargaProduk,
  required String kategoriProduk,
  required int stok,
  required File fotoProduk,
}) async {
  final dio = Dio();

  FormData formData = FormData.fromMap({
    'nama_produk': namaProduk,
    'harga_produk': hargaProduk,
    'kategori_produk': kategoriProduk,
    'stok': stok,
    'foto_produk': await MultipartFile.fromFile(
      fotoProduk.path,
      filename: fotoProduk.path.split('/').last,
    ),
  });

  try {
    final response = await dio.post(
      'http://10.0.2.2:8000/api/produk', 
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Produk dan foto berhasil diupload!');
    }
  } on DioException catch (e) {
    print('Gagal mengupload data: ${e.response?.data ?? e.message}');
    throw Exception('Upload failed');
  }
}