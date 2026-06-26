import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pnbfoods/models/kantin.dart';
import 'package:pnbfoods/services/base_url.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: BaseUrl.baseUrl,
    headers: {'Accept': 'application/json'},
  ),
);

Future<Kantin> fetchKantin(int id) async {
  final response = await dio.get('kantin/$id');

  if (response.statusCode == 200) {
    return Kantin.fromJson(response.data['data']);
  } else {
    throw Exception('Gagal mengambil kantin');
  }
}

Future<Kantin> fetchKantinByPenjual(int penjualId) async {
  final response = await dio.get('kantin/penjual/$penjualId');

  if (response.statusCode == 200) {
    return Kantin.fromJson(response.data['data']);
  } else {
    throw Exception('Gagal mengambil kantin penjual');
  }
}

Future<List<Kantin>> fetchSemuaKantin() async {
  final response = await dio.get('kantin');

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['data'];
    List<Kantin> daftarKantin = data.map((item) => Kantin.fromJson(item as Map<String, dynamic>)).toList();
    return daftarKantin;
  } else {
    throw Exception('Gagal mengambil semua kantin');
  }
}

Future<Kantin> postKantin({
  required String namaKantin,
  required String kategori,
  required File fotoKantin,
  required int penjualId,
}) async {
  FormData formData = FormData.fromMap({
    'nama_kantin': namaKantin,
    'kategori': kategori,
    'penjual_id': penjualId,
    'foto_kantin': await MultipartFile.fromFile(
      fotoKantin.path,
      filename: fotoKantin.path.split('/').last,
    ),
  });

  try {
    final response = await dio.post(
      'kantin',
      data: formData,
      options: Options(headers: {'Accept': 'application/json'}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('Kantin berhasil ditambahkan!');
      return Kantin.fromJson(response.data['data']);
    } else {
      throw Exception('Upload kantin gagal');
    }
  } on DioException catch (e) {
    print('Gagal menambahkan kantin: ${e.response?.data ?? e.message}');
    throw Exception('Upload kantin gagal');
  }
}

Future<Kantin> updateKantin({
  required int id,
  required String namaKantin,
  required String kategori,
  File? fotoKantin,
}) async {
  Map<String, dynamic> dataMap = {
    '_method': 'PUT',
    'nama_kantin': namaKantin,
    'kategori': kategori,
  };

  if (fotoKantin != null) {
    dataMap['foto_kantin'] = await MultipartFile.fromFile(
      fotoKantin.path,
      filename: fotoKantin.path.split('/').last,
    );
  }

  FormData formData = FormData.fromMap(dataMap);

  try {
    final response = await dio.post(
      'kantin/$id',
      data: formData,
      options: Options(headers: {'Accept': 'application/json'}),
    );

    if (response.statusCode == 200) {
      print('Kantin berhasil diperbarui!');
      return Kantin.fromJson(response.data['data']);
    } else {
      throw Exception('Update kantin gagal');
    }
  } on DioException catch (e) {
    print('Gagal memperbarui kantin: ${e.response?.data ?? e.message}');
    throw Exception('Update kantin gagal');
  }
}

Future<void> deleteKantin(int id) async {
  try {
    final response = await dio.delete('kantin/$id');

    if (response.statusCode == 200) {
      print('Kantin berhasil dihapus!');
    }
  } on DioException catch (e) {
    print('Gagal menghapus kantin: ${e.response?.data ?? e.message}');
    throw Exception('Hapus kantin gagal');
  }
}
