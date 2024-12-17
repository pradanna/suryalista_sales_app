import 'package:dio/dio.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/model/Customer.dart';

class CustomerService {
  final Dio _dio;
  CustomerService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Customer>> getTokoCustomers() async {
    try {
      final response = await _dio.get("$baseURL/api/customers/toko");
      if (response.statusCode == 200) {
        List data = response.data['data'];
        return data.map((customer) => Customer.fromJson(customer)).toList();
      } else {
        throw Exception("Failed to load customers");
      }
    } catch (e) {
      print("error Service customer $e");
      rethrow;
    }
  }
}
