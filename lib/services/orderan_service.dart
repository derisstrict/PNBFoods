import 'package:dio/dio.dart';
import 'package:pnbfoods/models/orderan.dart';
import 'package:pnbfoods/services/base_url.dart';

final dio = Dio(BaseOptions(
  baseUrl: BaseUrl.baseUrl,
  headers: {'Accept': 'application/json'},
));

Future<Orderan> fetchOrderan(int id) async {
  final response = await dio.get('orderan/$id');

  if (response.statusCode == 200) {
    return Orderan.fromJson(response.data['data']);
  } else {
    throw Exception('Gagal mengambil orderan');
  }
}

Future<List<Orderan>> fetchSemuaOrderan() async {
  final response = await dio.get('orderan');

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['data'];
    return data
        .map((item) => Orderan.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Gagal mengambil semua orderan');
  }
}

Future<Orderan> postOrderan({
  required String statusOrderan,
  required double totalHarga,
  required DateTime tanggalOrderan,
  required int pelangganId,
}) async {
  try {
    final response = await dio.post('orderan', data: {
      'status_orderan': statusOrderan,
      'total_harga': totalHarga,
      'tanggal_orderan': tanggalOrderan.toIso8601String(),
      'pelanggan_id': pelangganId,
    });

    if (response.statusCode == 201) {
      return Orderan.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal menambahkan orderan');
    }
  } on DioException catch (e) {
    throw Exception('Gagal menambahkan orderan: ${e.response?.data ?? e.message}');
  }
}

Future<Orderan> updateOrderan({
  required int id,
  String? statusOrderan,
  double? totalHarga,
  DateTime? tanggalOrderan,
}) async {
  try {
    final Map<String, dynamic> data = {
      '_method': 'PUT',
    };

    if (statusOrderan != null) data['status_orderan'] = statusOrderan;
    if (totalHarga != null) data['total_harga'] = totalHarga;
    if (tanggalOrderan != null) {
      data['tanggal_orderan'] = tanggalOrderan.toIso8601String();
    }

    final response = await dio.post('orderan/$id', data: data);

    if (response.statusCode == 200) {
      return Orderan.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal memperbarui orderan');
    }
  } on DioException catch (e) {
    throw Exception(
        'Gagal memperbarui orderan: ${e.response?.data ?? e.message}');
  }
}

Future<void> deleteOrderan(int id) async {
  try {
    final response = await dio.delete('orderan/$id');

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus orderan');
    }
  } on DioException catch (e) {
    throw Exception('Gagal menghapus orderan: ${e.response?.data ?? e.message}');
  }
}
