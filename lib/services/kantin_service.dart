import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pnbfoods/models/kantin.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://10.0.2.2:8000/api/',
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

Future<void> postKantin({
  required String namaKantin,
  required String kategori,
  required File fotoKantin,
}) async {
  FormData formData = FormData.fromMap({
    'nama_kantin': namaKantin,
    'kategori': kategori,
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
    }
  } on DioException catch (e) {
    print('Gagal menambahkan kantin: ${e.response?.data ?? e.message}');
    throw Exception('Upload kantin gagal');
  }
}

// masi bingung
