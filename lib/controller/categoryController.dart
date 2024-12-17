import 'package:get/get.dart';
import 'package:suryalita_sales_app/model/Category.dart';
import 'package:suryalita_sales_app/services/categoryService.dart';

class CategoryController extends GetxController {
  // RxList untuk menyimpan kategori
  RxBool isLoading = false.obs;
  RxList<Category> categories = RxList<Category>();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // Fetch categories dari API
  void fetchCategories() async {
    print('fetching categories');
    try {
      isLoading.value = true;
      final result = await CategoryService().fetchCategories();

      // Assign hasil ke RxList
      categories.value = result;
    } catch (e) {
      // Handle error
      print('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
