import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:pnbfoods/models/penjual.dart';
import 'package:pnbfoods/services/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Dio _dio = Dio(
  BaseOptions(
  baseUrl: BaseUrl.baseUrl,
  headers: {'Accept': 'application/json'},
  )
);

Future<Penjual> fetchPenjual(int idPenjual) async {

  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  try{ final response = await _dio.get(
      'penjual/$idPenjual',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      print(response.data['data']);
      return Penjual.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal mengambil data penjual');
    }
  } on DioException catch (e) {
    print("Eror HTTP ${e.response?.statusCode}: ${e.response?.data}");
    throw Exception('Gagal mengambil data penjual');
  }
}

Future<void> updatePenjual({
  required int idPenjual,
  required String namaPenjual,
  required String email,
  File? fotoProfile,
  bool hapusFoto = false,

}) async {

  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  Map<String, dynamic> data = {
    'nama': namaPenjual,
    'email': email
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
      'penjual/$idPenjual',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  } on DioException catch (e) {
    print("Eror Update: ${e.response?.data}");
  }
}

Future<Map<String, dynamic>> loginPenjual({
  required String email,
  required String password,
}) async {
  final response = await _dio.post('penjual/login', data: {
    'email': email,
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

Future<void> logoutPenjual() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  await _dio.post(
    'penjual/logout',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );

  await prefs.clear();
}

Future<Map<String, dynamic>> changePasswordPenjual({
  required String passwordLama,
  required String passwordBaru,
  required String passwordKonfirmasi,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token'); 

  final response = await _dio.post(
    'penjual/change-password',
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

Future<int> fetchSaldo(int penjualId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  final response = await _dio.get(
    'penjual/$penjualId/saldo',
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );

  return response.data['data']['saldo'] as int;
}

Future<void> tarikSaldo(int penjualId, int jumlah) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  await _dio.post(
    'penjual/$penjualId/tarik-saldo',
    data: {'jumlah': jumlah},
    options: Options(headers: {'Authorization': 'Bearer $token'}),
  );
}