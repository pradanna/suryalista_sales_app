import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/helper/dBhelper.dart';
import 'package:suryalita_sales_app/model/Cart.dart';
import 'package:suryalita_sales_app/services/cartService.dart';

class CartController extends GetxController {
  var successInput = false.obs;
  var loadingInputSqlite = false.obs;
  var loadingUploadCart = false.obs;
  var cartItems = <Cart>[].obs; // Daftar item keranjang
  var carts = [].obs;
  final _cartService = CartService();

  double get totalPrice {
    return cartItems.fold(
        0,
        (sum, item) =>
            sum + (item.price * item.qty.value)); // Gunakan quantity.value
  }

  void addItem(Cart item) {
    cartItems.add(item);
  }

  void removeItem(Cart item) {
    cartItems.remove(item);
  }

  Future<void> addToCart(String itemId, int qty, int price, String unit,
      String name, String image) async {
    loadingInputSqlite = true.obs;

    try {
      final total = qty * price;
      await DBHelper().insertCart({
        'item_id': itemId,
        'qty': qty,
        'price': price,
        'total': total,
        'unit': unit,
        'image': image,
        'name': name,
      });
      successInput = true.obs;
      print("Sukses");
    } catch (e) {
      // Handle the error
      print('Error adding to cart: $e');
      successInput = false.obs;
      throw Exception('Failed to add item to cart: $e');
    } finally {
      loadingInputSqlite = false.obs;
    }
  }

  void fetchCartItems() async {
    var data = await DBHelper().getCartItems();
    cartItems.value = data;
  }

  Future<void> uploadCartToServer(String customerId) async {
    loadingUploadCart = true.obs;
    try {
      print("1");
      final response = await _cartService.uploadCartToServer(customerId);
      print("2");
      print("2 $response");
      // Pastikan keranjang tidak kosong
      if (response == "berhasil") {
        print("cart Controller Sukses upload keranjang");
        Get.back();
      } else {
        print("error");
      }
    } catch (e) {
      print("cart Controller error $e");
    } finally {
      loadingUploadCart = false.obs;
    }
  }
}
