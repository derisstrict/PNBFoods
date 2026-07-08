import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUrl {
  static const String localhost = 'http://localhost:8000/api/';
  static const String emulator = 'http://10.0.2.2:8000/api/';
}

class BaseUrl {
  static String _baseUrl = GetUrl.localhost;
  static const String _prefsKey = 'selected_base_url';

  static String get baseUrl => _baseUrl;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _baseUrl = prefs.getString(_prefsKey) ?? GetUrl.localhost;
    _updateDio();
  }

  static Future<void> setBaseUrl(String url) async {
    _baseUrl = url;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, url);
    _updateDio();
  }

  static final Dio dio = Dio(BaseOptions(headers: {
    'Accept': 'application/json',
  }));

  static void _updateDio() {
    dio.options.baseUrl = _baseUrl;
  }
}
