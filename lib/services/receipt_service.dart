import 'api_service.dart';

class ReceiptService {
  /// Sends a receipt image to the backend AI parser and returns the extracted
  /// transaction fields ({ amount, description, transaction_date, type }).
  static Future<dynamic> scan({
    required List<int> bytes,
    required String filename,
  }) {
    return ApiService.uploadFile(
      '/receipt/scan',
      'receipt',
      bytes: bytes,
      filename: filename,
    );
  }
}
