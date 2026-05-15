import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/api_config.dart';

class ApiException implements Exception {
  ApiException(this.message, this.statusCode, [this.body]);

  final String message;
  final int statusCode;
  final dynamic body;

  @override
  String toString() => message;
}

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;

  static const String tokenKey = 'wealthwise_token';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) ?? prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    await prefs.setString('token', token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove('token');
  }

  static Future<bool> hasToken() async => (await getToken()) != null;

  static Future<dynamic> get(String path, {Map<String, String>? query}) {
    return _request('GET', path, query: query);
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) {
    return _request('POST', path, body: body);
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body) {
    return _request('PUT', path, body: body);
  }

  static Future<dynamic> delete(String path) {
    return _request('DELETE', path);
  }

  static Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final token = await getToken();
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    late final http.Response response;
    switch (method) {
      case 'POST':
        response = await http.post(
          uri,
          headers: headers,
          body: jsonEncode(body),
        );
        break;
      case 'PUT':
        response = await http.put(
          uri,
          headers: headers,
          body: jsonEncode(body),
        );
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: headers);
        break;
      default:
        response = await http.get(uri, headers: headers);
    }

    dynamic decoded;
    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = response.body;
      }
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(_messageFrom(decoded), response.statusCode, decoded);
    }
    return decoded;
  }

  static String _messageFrom(dynamic decoded) {
    if (decoded is Map) {
      if (decoded['message'] != null) return decoded['message'].toString();
      if (decoded['errors'] is Map && (decoded['errors'] as Map).isNotEmpty) {
        final first = (decoded['errors'] as Map).values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
        return first.toString();
      }
    }
    return 'Request gagal. Periksa koneksi atau server Laravel.';
  }
}
