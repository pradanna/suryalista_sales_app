import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/model/Customer.dart';

class CustomerService {
  final Dio _dio;
  CustomerService({Dio? dio}) : _dio = dio ?? Dio();
  final GetStorage box = GetStorage();

  Future<List<Customer>> getTokoCustomers() async {
    String token = await box.read('token_litasurya') ?? '';

    try {
      final response = await _dio.get("$baseURL/api/customers/toko" ,
        options: Options(
            headers: {
              'Authorization': 'Bearer $token',  // Menambahkan header Authorization
              'Accept': 'application/json',      // Optional: menambahkan header Accept
            }
        ),);
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
