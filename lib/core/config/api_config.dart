import 'package:flutter/foundation.dart';

class ApiConfig {
  const ApiConfig._();

  static String get baseUrl {
    const overrideUrl = String.fromEnvironment('API_BASE_URL');
    if (overrideUrl.isNotEmpty) return overrideUrl;
    return kIsWeb ? 'http://localhost:8000/api' : 'http://10.0.2.2:8000/api';
  }
}
