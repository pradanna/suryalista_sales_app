import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suryalita_sales_app/Components/snackbar/showSnackbar.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/model/Item.dart';
import 'package:suryalita_sales_app/model/paginationMeta.dart';

class ItemService {
  final Dio _dio;
  final GetStorage box = GetStorage();

  ItemService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> fetchItems({
    String? categoryId,
    String? search,
    String? sortBy = 'name',
    String? sortOrder = 'asc',
    int page = 1,
  }) async {
    try {
      String token = await box.read('token_litasurya') ?? '';

      final response = await _dio.get(
        '$baseURL/api/items',
        queryParameters: {
          'category_id': categoryId,
          'search': search,
          'sort_by': sortBy,
          'sort_order': sortOrder,
          'page': page,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          // Menambahkan header Authorization
          'Accept': 'application/json',
          // Optional: menambahkan header Accept
        }),
      );

      if (response.statusCode == 200) {
        if (response.data['success'] == false) {
          return {'items': null};
        }
        print("1");
        final List data = response.data['data'];
        print("2");
        final PaginationMeta pagination =
            PaginationMeta.fromJson(response.data['pagination']);
        print("3");
        return {
          'items': data.map((item) => Item.fromJson(item)).toList(),
          'pagination': pagination
        };
      } else {
        // Tangani error lain jika perlu
        throw Exception('Unexpected error with status: ${response.statusCode}');
      }
    } catch (e) {
      // Tangani error di luar status 404
      print("itemService error fetch data $e");
      throw Exception('Error fetching items: $e');
    }
  }

  Future<Map<String, dynamic>> fetchDetailProduct({String? id}) async {
    try {
      String token = await box.read('token_litasurya') ?? '';
      final response = await _dio.get(
        '$baseURL/api/items/$id',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          // Menambahkan header Authorization
          'Accept': 'application/json',
          // Optional: menambahkan header Accept
        }),
      );
      print("itemService fetching data");

      if (response.statusCode == 200) {
        if (response.data['success'] == false) {
          return {'items': null};
        }
        print("hehe");
        final Item item = Item.fromJson(response.data['data']);
        print("fetch data $item");

        return {'item': item};
      } else {
        // Tangani error lain jika perlu
        throw Exception('Unexpected error with status: ${response.statusCode}');
      }
    } catch (e) {
      // Tangani error di luar status 404
      print("itemService error fetch data $e");
      throw Exception('Error fetching items: $e');
    }
  }
}
