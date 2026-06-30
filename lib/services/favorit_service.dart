import 'package:dio/dio.dart';
import 'package:pnbfoods/services/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Dio _dio = Dio(
  BaseOptions(
    baseUrl: BaseUrl.baseUrl,
    headers: {'Accept': 'application/json'},
  ),
);

Future<List<Map<String, dynamic>>> getFavorit() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final pelangganId = prefs.getInt('userId') ?? 0;

  try {
    final response = await _dio.get(
      'favorit',
      queryParameters: {'pelanggan_id': pelangganId},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.data['success'] == true) {
      return List<Map<String, dynamic>>.from(response.data['data']);
    }
    throw Exception('Gagal mengambil daftar favorit');
  } on DioException catch (e) {
    throw Exception('Gagal mengambil daftar favorit: ${e.response?.data ?? e.message}');
  }
}

Future<Map<String, dynamic>> toggleFavorit(int produkId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final pelangganId = prefs.getInt('userId') ?? 0;

  try {
    final response = await _dio.post(
      'favorit',
      data: {
        'pelanggan_id': pelangganId,
        'produk_id': produkId,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.data['success'] == true) {
      return {'is_favorit': response.data['is_favorit'] as bool};
    }
    throw Exception('Gagal mengubah status favorit');
  } on DioException catch (e) {
    throw Exception('Gagal mengubah status favorit: ${e.response?.data ?? e.message}');
  }
}

Future<void> hapusFavorit(int favoritId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  try {
    await _dio.delete(
      'favorit/$favoritId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  } on DioException catch (e) {
    throw Exception('Gagal menghapus favorit: ${e.response?.data ?? e.message}');
  }
}

Future<Map<String, dynamic>> cekFavorit(int produkId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final pelangganId = prefs.getInt('userId') ?? 0;

  try {
    final response = await _dio.get(
      'favorit/cek',
      queryParameters: {
        'pelanggan_id': pelangganId,
        'produk_id': produkId,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return {
      'is_favorit': response.data['is_favorit'] as bool,
      'favorit_id': response.data['favorit_id'],
    };
  } on DioException catch (e) {
    throw Exception('Gagal mengecek status favorit: ${e.response?.data ?? e.message}');
  }
}
