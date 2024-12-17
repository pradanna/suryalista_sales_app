import 'package:dio/dio.dart';
import 'package:suryalita_sales_app/Components/helper/dBhelper.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/model/Cart.dart';

class CartService {
  final Dio _dio = Dio();
  final dbHelper = DBHelper();

  Future<String> uploadCartToServer(String customerId) async {
    try {
      // Ambil data cart dari SQLite
      final List<Cart> cartItems = await dbHelper.getCartItems();

      if (cartItems.isEmpty) {
        print('Keranjang kosong, tidak ada yang diunggah.');
        return "keranjang kosong";
      }

      // Hitung total harga
      double total = cartItems.fold(0, (sum, item) => sum + (item.total ?? 0));

      // Siapkan payload untuk API
      final Map<String, dynamic> payload = {
        'customer_id': customerId,
        'total': total,
        'cart_items': cartItems.map((cart) {
          return {
            'item_id': cart.itemId,
            'qty': cart.qty,
            'price': cart.price,
            'total': cart.total,
            'unit': cart.unit,
          };
        }).toList(), // Konversi cart items menjadi format yang sesuai API
      };

      print("Mengirim data ke API: $baseURL/api/cart/upload");
      print("PAYLOAD: ${payload.toString()}");

      // Kirim ke server untuk memproses transaksi
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
      ));

      final response = await _dio.post('$baseURL/api/cart/upload',
          data: payload,
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ));

      print("Respons data: ${response.data}");
      print("Respons status code: ${response.statusCode}");

      // Cek respons server
      if (response.statusCode == 201) {
        // Sesuai dengan HTTP 201 Created
        final transactionId = response.data['transaction_id'];
        print('Data berhasil diunggah dengan transaction_id: $transactionId');

        await dbHelper.clearCart(); // Hapus data lokal jika berhasil
        return "berhasil";
      } else {
        print('Gagal mengunggah data: ${response.statusCode}');
        print('Respons: ${response.data}');
        return "gagal mengunggah";
      }
    } on DioException catch (dioError) {
      // Menangani error yang berasal dari Dio
      if (dioError.response != null) {
        print('Error dari server: ${dioError.response?.statusCode}');
        print('Pesan error: ${dioError.response?.data}');
        return "server error";
      } else {
        print('Error tanpa respons: ${dioError.message}');
        return "server error";
      }
    } catch (e) {
      // Menangani error lain yang tidak terduga
      print('Error tidak terduga: $e');
      return "server error";
    }
  }
}
