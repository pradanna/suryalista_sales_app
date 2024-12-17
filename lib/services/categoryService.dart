import 'package:dio/dio.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/model/Category.dart';

class CategoryService {
  final Dio _dio = Dio();

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get('$baseURL/api/categories');

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;

        // Mapping data ke model Category
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching categories: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
