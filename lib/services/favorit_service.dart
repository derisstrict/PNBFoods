import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Ganti sesuai IP/base URL Laravel kamu
const String _baseUrl = 'http://10.0.2.2:8000/api';

class FavoritService {
  /// Ambil token dan pelanggan_id dari SharedPreferences
  static Future<Map<String, dynamic>> _getAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final pelangganId = prefs.getInt('pelanggan_id') ?? 0;
    return {'token': token, 'pelanggan_id': pelangganId};
  }

  /// GET /api/favorit?pelanggan_id={id}
  /// Ambil semua favorit milik pelanggan yang sedang login
  static Future<List<Map<String, dynamic>>> getFavorit() async {
    final auth = await _getAuth();
    final pelangganId = auth['pelanggan_id'];

    final response = await http.get(
      Uri.parse('$_baseUrl/favorit?pelanggan_id=$pelangganId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${auth['token']}',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        return List<Map<String, dynamic>>.from(body['data']);
      }
    }
    throw Exception('Gagal mengambil daftar favorit');
  }

  /// POST /api/favorit
  /// Toggle favorit: kalau belum difavoritkan → tambah, kalau sudah → hapus
  /// Return: { is_favorit: bool, favorit_id: int? }
  static Future<Map<String, dynamic>> toggleFavorit(int produkId) async {
    final auth = await _getAuth();

    final response = await http.post(
      Uri.parse('$_baseUrl/favorit'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${auth['token']}',
      },
      body: jsonEncode({
        'pelanggan_id': auth['pelanggan_id'],
        'produk_id': produkId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        return {
          'is_favorit': body['is_favorit'] as bool,
        };
      }
    }
    throw Exception('Gagal mengubah status favorit');
  }

  /// DELETE /api/favorit/{favoritId}
  /// Hapus favorit berdasarkan ID favorit (bukan produk ID)
  static Future<void> hapusFavorit(int favoritId) async {
    final auth = await _getAuth();

    final response = await http.delete(
      Uri.parse('$_baseUrl/favorit/$favoritId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${auth['token']}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus favorit');
    }
  }

  /// GET /api/favorit/cek?pelanggan_id={id}&produk_id={id}
  /// Cek apakah produk sudah difavoritkan
  static Future<Map<String, dynamic>> cekFavorit(int produkId) async {
    final auth = await _getAuth();
    final pelangganId = auth['pelanggan_id'];

    final response = await http.get(
      Uri.parse('$_baseUrl/favorit/cek?pelanggan_id=$pelangganId&produk_id=$produkId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${auth['token']}',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return {
        'is_favorit': body['is_favorit'] as bool,
        'favorit_id': body['favorit_id'],
      };
    }
    throw Exception('Gagal mengecek status favorit');
  }
}