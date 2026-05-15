import 'api_service.dart';

class AccountService {
  static Future<dynamic> getAccounts() => ApiService.get('/accounts');
  static Future<dynamic> getAccount(Object id) =>
      ApiService.get('/accounts/$id');
  static Future<dynamic> createAccount(Map<String, dynamic> data) =>
      ApiService.post('/accounts', data);
  static Future<dynamic> updateAccount(Object id, Map<String, dynamic> data) =>
      ApiService.put('/accounts/$id', data);
  static Future<dynamic> deleteAccount(Object id) =>
      ApiService.delete('/accounts/$id');
}
