import 'package:dio/dio.dart';
import 'package:pnbfoods/models/notifikasi.dart';
import 'package:pnbfoods/services/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dio = BaseUrl.dio;

Future<Map<String, dynamic>> getAuthHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  return {
    'Authorization': 'Bearer $token',
  };
}

Future<List<NotifikasiModel>> fetchNotifikasi() async {
  final headers = await getAuthHeaders();
  final response = await dio.get(
    'notifikasi',
    options: Options(headers: headers),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['data'];
    return data
        .map((item) => NotifikasiModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  throw Exception('Gagal mengambil notifikasi');
}

Future<int> fetchUnreadCount() async {
  final headers = await getAuthHeaders();
  final response = await dio.get(
    'notifikasi/unread',
    options: Options(headers: headers),
  );

  if (response.statusCode == 200) {
    return response.data['count'] as int;
  }
  return 0;
}

Future<void> markNotifikasiAsRead(int id) async {
  final headers = await getAuthHeaders();
  await dio.put(
    'notifikasi/$id/read',
    options: Options(headers: headers),
  );
}

Future<void> markAllNotifikasiAsRead() async {
  final headers = await getAuthHeaders();
  await dio.put(
    'notifikasi/read-all',
    options: Options(headers: headers),
  );
}
