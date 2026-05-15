import 'api_service.dart';

class CategoryService {
  static Future<dynamic> getCategories() => ApiService.get('/categories');
  static Future<dynamic> getCategory(Object id) =>
      ApiService.get('/categories/$id');
  static Future<dynamic> createCategory(Map<String, dynamic> data) =>
      ApiService.post('/categories/add', data);
  static Future<dynamic> updateCategory(Object id, Map<String, dynamic> data) =>
      ApiService.put('/categories/$id', data);
  static Future<dynamic> deleteCategory(Object id) =>
      ApiService.delete('/categories/$id');
}
