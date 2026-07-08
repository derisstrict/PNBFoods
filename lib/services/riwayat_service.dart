import 'package:dio/dio.dart';
import 'package:pnbfoods/models/item_riwayat.dart';
import 'package:pnbfoods/services/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

final _dio = BaseUrl.dio;

Future<List<TransaksiRiwayat>> fetchRiwayat() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  debugPrint('TOKEN RIWAYAT: $token');

  try {
    final response = await _dio.get(
      'orderan/riwayat',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data
          .map((item) => TransaksiRiwayat.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal mengambil riwayat');
    }
  } on DioException catch (e) {
    debugPrint('Error riwayat: ${e.response?.data ?? e.message}');
    throw Exception('Gagal mengambil riwayat');
  }
}