import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:pnbfoods/models/produk.dart';
import 'package:pnbfoods/services/base_url.dart';

final dio = BaseUrl.dio;

Future<Produk> fetchProduk(int id) async {
  final response = await dio.get('produk/$id');

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

Future<List<Produk>> fetchProdukByPenjual(int id) async {
  final response = await dio.get('produk/penjual/$id');

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['data'];
    List<Produk> daftarProduk = data.map((item) => Produk.fromJson(item as Map<String, dynamic>)).toList();
    return daftarProduk;
  } else {
    throw Exception('Gagal mengambil produk kantin');
  }
}

Future<void> postProduk({
  required String namaProduk,
  required String deskripsiProduk,
  required int hargaProduk,
  required String kategoriProduk,
  required int stok,
  required int penjualId,
  required File fotoProduk,
}) async {
  FormData formData = FormData.fromMap({
    'nama_produk': namaProduk,
    'harga_produk': hargaProduk,
    'deskripsi_produk': deskripsiProduk,
    'kategori_produk': kategoriProduk,
    'stok': stok,
    'penjual_id': penjualId,
    'foto_produk': await MultipartFile.fromFile(
      fotoProduk.path,
      filename: fotoProduk.path.split('/').last,
    ),
  });

  try {
    final response = await dio.post(
      'produk', 
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

Future<void> updateProduk({
  required int idProduk,
  required String namaProduk,
  required String deskripsiProduk,
  required int hargaProduk,
  required String kategoriProduk,
  required int stok,
  required int penjualId,
  File? fotoProduk,
}) async {

  final Map<String, dynamic> mapData = {
    '_method': 'PUT',
    'nama_produk': namaProduk,
    'harga_produk': hargaProduk,
    'deskripsi_produk': deskripsiProduk,
    'kategori_produk': kategoriProduk,
    'stok': stok,
    'penjual_id': penjualId
  };

  if (fotoProduk != null) {
    mapData['foto_produk'] = await MultipartFile.fromFile(
      fotoProduk.path,
      filename: fotoProduk.path.split('/').last,
    );
  }

  FormData formData = FormData.fromMap(mapData);

  try {
    final response = await dio.post(
      'produk/$idProduk', 
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Produk berhasil diperbarui!');
    }
  } on DioException catch (e) {
    print('Gagal memperbarui data: ${e.response?.data ?? e.message}');
    throw Exception('Update failed');
  }
}

Future<void> deleteProduk(int id) async {
  try {
    final response = await dio.delete('produk/$id');

    if (response.statusCode == 200) {
      print('Produk berhasil dihapus!');
    }
  } on DioException catch (e) {
    print('Gagal menghapus produk: ${e.response?.data ?? e.message}');
    throw Exception('Hapus produk gagal');
  }
}