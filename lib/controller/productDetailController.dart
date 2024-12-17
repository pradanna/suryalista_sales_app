import 'package:get/get.dart';
import 'package:suryalita_sales_app/model/Item.dart';
import 'package:suryalita_sales_app/services/itemService.dart';

class ProductDetailController extends GetxController {
  final ItemService _itemService = ItemService();

  var selectedUnit = 'Lusin'.obs;
  var selectedPrice = 120000.obs;
  var quantity = 1.obs;
  var totalPrice = 150000.obs;
  var isEmpty = false.obs;
  var isLoading = false.obs;
  var item = Rxn<Item>();

  void setSelectedUnit(String unit, int price) {
    selectedUnit.value = unit;
    selectedPrice.value = price;
    calculateTotalPrice();
  }

  void increaseQuantity() {
    quantity.value++;
    calculateTotalPrice();
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
      calculateTotalPrice();
    }
  }

  void calculateTotalPrice() {
    totalPrice.value = selectedPrice.value * quantity.value;
  }

  Future<void> fetchItems(String id) async {
    try {
      isLoading.value = true;
      final fetchedItem = await _itemService.fetchDetailProduct(id: id);

      if (fetchedItem['item'] != null) {
        item.value = fetchedItem['item'];
      } else {
        isEmpty.value = true; // Tandai data kosong
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load items: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
