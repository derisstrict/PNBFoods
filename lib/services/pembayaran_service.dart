import 'package:dio/dio.dart';
import 'package:pnbfoods/models/pembayaran.dart';
import 'package:pnbfoods/services/base_url.dart';

final dio = Dio(BaseOptions(
  baseUrl: BaseUrl.baseUrl,
  headers: {'Accept': 'application/json'},
));

Future<Pembayaran> fetchPembayaran(int id) async {
  final response = await dio.get('pembayaran/$id');

  if (response.statusCode == 200) {
    return Pembayaran.fromJson(response.data['data']);
  } else {
    throw Exception('Gagal mengambil pembayaran');
  }
}

Future<List<Pembayaran>> fetchSemuaPembayaran() async {
  final response = await dio.get('pembayaran');

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['data'];
    return data
        .map((item) => Pembayaran.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Gagal mengambil semua pembayaran');
  }
}

Future<Pembayaran> postPembayaran({
  required int orderanId,
  required String metodePembayaran,
  required double totalPembayaran,
  required String statusPembayaran,
}) async {
  try {
    final response = await dio.post('pembayaran', data: {
      'orderan_id': orderanId,
      'metode_pembayaran': metodePembayaran,
      'total_pembayaran': totalPembayaran,
      'status_pembayaran': statusPembayaran,
    });

    if (response.statusCode == 201) {
      return Pembayaran.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal menambahkan pembayaran');
    }
  } on DioException catch (e) {
    throw Exception(
        'Gagal menambahkan pembayaran: ${e.response?.data ?? e.message}');
  }
}

Future<Pembayaran> updatePembayaran({
  required int id,
  String? metodePembayaran,
  double? totalPembayaran,
  String? statusPembayaran,
}) async {
  try {
    final Map<String, dynamic> data = {
      '_method': 'PUT',
    };

    if (metodePembayaran != null) data['metode_pembayaran'] = metodePembayaran;
    if (totalPembayaran != null) data['total_pembayaran'] = totalPembayaran;
    if (statusPembayaran != null) data['status_pembayaran'] = statusPembayaran;

    final response = await dio.post('pembayaran/$id', data: data);

    if (response.statusCode == 200) {
      return Pembayaran.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal memperbarui pembayaran');
    }
  } on DioException catch (e) {
    throw Exception(
        'Gagal memperbarui pembayaran: ${e.response?.data ?? e.message}');
  }
}

Future<void> deletePembayaran(int id) async {
  try {
    final response = await dio.delete('pembayaran/$id');

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus pembayaran');
    }
  } on DioException catch (e) {
    throw Exception(
        'Gagal menghapus pembayaran: ${e.response?.data ?? e.message}');
  }
}
