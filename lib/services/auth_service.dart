import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await ApiService.post('/login', {
      'email': email,
      'password': password,
    });
    if (data is Map && data['access_token'] != null) {
      await ApiService.saveToken(data['access_token'].toString());
    }
    return Map<String, dynamic>.from(data as Map);
  }

  static Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    await ApiService.post('/register', {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  static Future<bool> isLoggedIn() => ApiService.hasToken();

  static Future<void> logout() async {
    try {
      await ApiService.post('/logout', {});
    } finally {
      await ApiService.clearToken();
    }
  }
}
