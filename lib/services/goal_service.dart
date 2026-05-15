import 'api_service.dart';

class GoalService {
  static Future<dynamic> getGoals() => ApiService.get('/goals');
  static Future<dynamic> getGoal(Object id) => ApiService.get('/goals/$id');
  static Future<dynamic> createGoal(Map<String, dynamic> data) =>
      ApiService.post('/goals', data);
  static Future<dynamic> updateGoal(Object id, Map<String, dynamic> data) =>
      ApiService.put('/goals/$id', data);
  static Future<dynamic> deleteGoal(Object id) =>
      ApiService.delete('/goals/$id');
  static Future<dynamic> updateFunds(Object id, Map<String, dynamic> data) =>
      ApiService.put('/goals/$id/funds', data);
}
