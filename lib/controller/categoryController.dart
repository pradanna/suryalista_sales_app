import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/CustomErrorBottomSheet.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/model/Category.dart';

class CategoryController extends GetxController {
  final Dio _dio = Dio();
  final GetStorage box = GetStorage();

  RxBool isLoading = false.obs;
  RxList<Category> categories = RxList<Category>();
  bool isErrorDisplayed = false;

  @override
  void onInit() {
    super.onInit();
  }

  // Fetch categories from API
  Future<void> fetchCategories(context) async {
    String token = await box.read('token_litasurya') ?? '';

    String error_type = '';
    try {
      isLoading.value = true;
      final response = await _dio.get(
        '$baseURL/api/categories',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          // Menambahkan header Authorization
          'Accept': 'application/json',
          // Optional: menambahkan header Accept
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        categories.value = data.map((json) => Category.fromJson(json)).toList();
      } else {
        error_type = 'server_error';
        // throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle different DioExceptions
      if (e.type == DioExceptionType.connectionTimeout) {
        // Timeout error
        error_type = 'timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        // Receive Timeout error
        error_type = 'timeout';
      } else if (e.type == DioExceptionType.badResponse) {
        // Server error, e.g., 500 or 404
        error_type = 'server_error';
      } else if (e.type == DioExceptionType.connectionError) {
        // Network error, e.g., no internet
        error_type = 'no_internet';
      } else if (e.type == DioExceptionType.unknown) {
        // Network error, e.g., no internet
        error_type = 'unknown';
      }
    } catch (e) {
      // General error handling
      error_type = 'unknown';
    } finally {
      isLoading.value = false;

      if (error_type != '' && !isErrorDisplayed) {
        isErrorDisplayed = true;

        Future.delayed(Duration(seconds: 2), () {
          isErrorDisplayed = false;
        });

        showCustomErrorBottomSheet(
          context: context,
          errorType: error_type,
          onRetry: () {
            fetchCategories(context);
            isErrorDisplayed = false;
          },
        );
      }
    }
  }
}
