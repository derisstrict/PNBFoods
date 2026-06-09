import 'package:dio/dio.dart';
import 'package:pnbfoods/models/favorit.dart';

final dio = Dio(BaseOptions(
  baseUrl: 'http://localhost:8000/api/',
  headers: {'Accept': 'application/json'},
));

Future<Favorit> fetchFavorit(int id) async {
  final response = await dio.get('favorit/$id');

  if (response.statusCode == 200) {
    return Favorit.fromJson(response.data['data']);
  } else {
    throw Exception('Gagal mengambil favorit');
  }
}

Future<List<Favorit>> fetchSemuaFavorit() async {
  final response = await dio.get('favorit');

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['data'];
    return data
        .map((item) => Favorit.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Gagal mengambil semua favorit');
  }
}

Future<Favorit> postFavorit({
  required int pelangganId,
  required int produkId,
}) async {
  try {
    final response = await dio.post('favorit', data: {
      'pelanggan_id': pelangganId,
      'produk_id': produkId,
    });

    if (response.statusCode == 201) {
      return Favorit.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal menambahkan favorit');
    }
  } on DioException catch (e) {
    throw Exception(
        'Gagal menambahkan favorit: ${e.response?.data ?? e.message}');
  }
}

Future<Favorit> updateFavorit({
  required int id,
  int? pelangganId,
  int? produkId,
}) async {
  try {
    final Map<String, dynamic> data = {
      '_method': 'PUT',
    };

    if (pelangganId != null) data['pelanggan_id'] = pelangganId;
    if (produkId != null) data['produk_id'] = produkId;

    final response = await dio.post('favorit/$id', data: data);

    if (response.statusCode == 200) {
      return Favorit.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal memperbarui favorit');
    }
  } on DioException catch (e) {
    throw Exception(
        'Gagal memperbarui favorit: ${e.response?.data ?? e.message}');
  }
}

Future<void> deleteFavorit(int id) async {
  try {
    final response = await dio.delete('favorit/$id');

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus favorit');
    }
  } on DioException catch (e) {
    throw Exception(
        'Gagal menghapus favorit: ${e.response?.data ?? e.message}');
  }
}
