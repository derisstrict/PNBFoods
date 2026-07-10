import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:pnbfoods/models/pelanggan.dart';
import 'package:pnbfoods/services/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _dio = BaseUrl.dio;

Future<Pelanggan> fetchPelanggan(int idPelanggan) async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  try {
    final response = await _dio.get(
      'pelanggan/$idPelanggan',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      print(response.data['data']);
      return Pelanggan.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal mengambil data pelanggan');
    }
  } on DioException catch (e) {
    print("Eror HTTP ${e.response?.statusCode}: ${e.response?.data}");
    throw Exception('Gagal mengambil data pelanggan');
  }
}

Future<void> updatePelanggan({
  required int idPelanggan,
  required String namaPelanggan,
  required String nim,
  File? fotoProfile,
  bool hapusFoto = false,
}) async {

  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  Map<String, dynamic> data = {
    'nama': namaPelanggan,
    'nim': nim
  };

  if (fotoProfile != null) {
    data['foto_profile'] = await MultipartFile.fromFile(
      fotoProfile.path,
      filename: fotoProfile.path.split('/').last,
    );
  } else if (hapusFoto) {
    data['hapus_foto'] = '1';
  }

  FormData formData = FormData.fromMap(data);

  try {
    await _dio.put(
      'pelanggan/$idPelanggan',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  } on DioException catch (e) {
    print("Eror Update: ${e.response?.data}");
    final message = e.response?.data['message'] ?? 'Gagal mengupdate data pelanggan';
    throw Exception(message);
  }
}

Future<Map<String, dynamic>> loginPelanggan({
  required String nim,
  required String password,
}) async {
  final response = await _dio.post('pelanggan/login', data: {
    'nim': nim,
    'password': password,
  });

  if (response.data['success'] == true) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.data['token']);
    await prefs.setString('role', response.data['role']);
    await prefs.setInt('userId', response.data['data']['id']);
  }

  return response.data;
}

Future<void> logoutPelanggan() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  await _dio.post(
    'pelanggan/logout',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );

  await prefs.clear();
}

Future<Map<String, dynamic>> changePasswordPelanggan({
  required String passwordLama,
  required String passwordBaru,
  required String passwordKonfirmasi,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final response = await _dio.post(
    'pelanggan/change-password',
    data: {
      'password_lama': passwordLama,
      'password': passwordBaru,
      'password_confirmation': passwordKonfirmasi,
    },
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
  );
  return response.data;
}