import 'api_service.dart';

class TransactionService {
  static Future<dynamic> getTransactions() => ApiService.get('/transactions');
  static Future<dynamic> getTransaction(Object id) =>
      ApiService.get('/transactions/$id');
  static Future<dynamic> createTransaction(Map<String, dynamic> data) =>
      ApiService.post('/transactions/add', data);
  static Future<dynamic> updateTransaction(
    Object id,
    Map<String, dynamic> data,
  ) => ApiService.put('/transactions/$id', data);
  static Future<dynamic> deleteTransaction(Object id) =>
      ApiService.delete('/transactions/$id');
}
