// lib/services/transaction_service.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';

class TransactionService {
  final Dio _dio = Dio();
  final GetStorage box = GetStorage();

  Future<Map<String, dynamic>> fetchTransactions({
    required String search,
    required int page,
  }) async {
    try {
      String token = await box.read('token_litasurya') ?? '';

      final response = await _dio.get(
        '$baseURL/api/transactions',
        queryParameters: {
          'search': search,
          'page': page,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          // Menambahkan header Authorization
          'Accept': 'application/json',
          // Optional: menambahkan header Accept
        }),
      );
      return response.data;
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }
}
