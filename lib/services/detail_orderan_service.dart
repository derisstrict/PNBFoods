import 'package:dio/dio.dart';
import 'package:pnbfoods/models/detail_orderan.dart';
import 'package:pnbfoods/services/base_url.dart';

final dio = BaseUrl.dio;

Future<DetailOrderan> fetchDetailOrderan(int id) async {
  final response = await dio.get('detail-orderan/$id');

  if (response.statusCode == 200) {
    return DetailOrderan.fromJson(response.data['data']);
  } else {
    throw Exception('Gagal mengambil detail orderan');
  }
}

Future<List<DetailOrderan>> fetchSemuaDetailOrderan() async {
  final response = await dio.get('detail-orderan');

  if (response.statusCode == 200) {
    final List<dynamic> data = response.data['data'];
    return data
        .map((item) => DetailOrderan.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Gagal mengambil semua detail orderan');
  }
}

Future<DetailOrderan> postDetailOrderan({
  required int orderanId,
  required int produkId,
  required int jumlah,
  String? catatan,
}) async {
  try {
    final response = await dio.post('detail-orderan', data: {
      'orderan_id': orderanId,
      'produk_id': produkId,
      'jumlah': jumlah,
      if (catatan != null) 'catatan': catatan,
    });

    if (response.statusCode == 201) {
      return DetailOrderan.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal menambahkan detail orderan');
    }
  } on DioException catch (e) {
    throw Exception(
        'Gagal menambahkan detail orderan: ${e.response?.data ?? e.message}');
  }
}

Future<DetailOrderan> updateDetailOrderan({
  required int id,
  int? jumlah,
  String? catatan,
}) async {
  try {
    final Map<String, dynamic> data = {
      '_method': 'PUT',
    };

    if (jumlah != null) data['jumlah'] = jumlah;
    if (catatan != null) data['catatan'] = catatan;

    final response = await dio.post('detail-orderan/$id', data: data);

    if (response.statusCode == 200) {
      return DetailOrderan.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal memperbarui detail orderan');
    }
  } on DioException catch (e) {
    throw Exception(
        'Gagal memperbarui detail orderan: ${e.response?.data ?? e.message}');
  }
}

Future<void> deleteDetailOrderan(int id) async {
  try {
    final response = await dio.delete('detail-orderan/$id');

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus detail orderan');
    }
  } on DioException catch (e) {
    throw Exception(
        'Gagal menghapus detail orderan: ${e.response?.data ?? e.message}');
  }
}
