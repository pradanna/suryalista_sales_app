// lib/services/transaction_service.dart
import 'package:dio/dio.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';

class TransactionService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> fetchTransactions({
    required String search,
    required int page,
  }) async {
    try {
      final response = await _dio.get(
        '$baseURL/api/transactions',
        queryParameters: {
          'search': search,
          'page': page,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }
}
