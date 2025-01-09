import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/helper/dBhelper.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/controller/homeController.dart';
import 'package:suryalita_sales_app/model/Cart.dart';
import 'package:suryalita_sales_app/services/cartService.dart';

class CartController extends GetxController {
  var successInput = false.obs;
  var loadingInputSqlite = false.obs;
  var loadingUploadCart = false.obs;
  var isError = false.obs;
  var cartItems = <Cart>[].obs; // Daftar item keranjang
  final _cartService = CartService();
  final HomeController homeController = Get.find<HomeController>();

  final DBHelper dbHelper = DBHelper();

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
    loadingInputSqlite.value = true;

    try {
      final total = qty * price;
      await DBHelper().insertCart(
        {
          'id' : generateUuid(),
          'item_id' : itemId,
          'qty' : qty,
          'request_qty' : qty,
          'price' : price,
          'total' : total,
          'status' : 'pending',
          'unit' : unit,
          'image' : image,
          'item_name' : name,
        }
      );
      homeController.updateCartItemCount();
      successInput.value = true;

      print("Sukses");
    } catch (e) {
      // Handle the error
      print('Error adding to cart: $e');
      successInput.value = false;
      throw Exception('Failed to add item to cart: $e');
    } finally {
      loadingInputSqlite.value = false;
    }
  }

  void fetchCartItems() async {
    var data = await DBHelper().getCartItems();
    cartItems.value = data;
  }

  Future<void> updateCartQuantity(String id, int newQty, int price) async {

    try {
      await dbHelper.updateCartQuantity(id, newQty, price);
      homeController.updateCartItemCount();
    }catch(e){
      print("error $e" );
    }
  }


  Future<bool> uploadCartToServer(String customerId) async {
    loadingUploadCart.value = true;

    try {
      // Lakukan request ke server
      await _cartService.uploadCartToServer(customerId);

      // Jika berhasil
      successInput.value = true;
      homeController.updateCartItemCount();
      return true;
    } catch (e) {
      // Jika gagal
      successInput.value = false;
      print("cart Controller error $e");
      return false;
    } finally {
      // Mengatur ulang loading tanpa menimpa nilai return
      loadingUploadCart.value = false;
    }
  }

}
