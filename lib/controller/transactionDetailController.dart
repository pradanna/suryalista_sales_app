import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/model/Transaction.dart';

class TransactionDetailController extends GetxController {
  final Dio _dio = Dio();
  var transaction = Rxn<Transaction>();
  var isLoading = false.obs;
  var loadingUpdateStatus = false.obs;
  final GetStorage box = GetStorage();

  Future<void> fetchTransactionDetail(String id) async {
    isLoading.value = true;
    String token = await box.read('token_litasurya') ?? '';
    try {
      final response = await _dio.get('$baseURL/api/transactions/$id',
        options: Options(
            headers: {
              'Authorization': 'Bearer $token',  // Menambahkan header Authorization
              'Accept': 'application/json',      // Optional: menambahkan header Accept
            }
        ),);
      transaction.value = Transaction.fromJson(response.data);
    } catch (e) {
      print('Error fetching transaction detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateTransactionStatus(String id) async {
    loadingUpdateStatus.value = true;
    String token = await box.read('token_litasurya') ?? '';
    try {

      // Kirim permintaan POST ke endpoint Laravel
      final response = await _dio.post(
        '$baseURL/api/transactions/$id/complete',
        options: Options(
            headers: {
              'Authorization': 'Bearer $token',  // Menambahkan header Authorization
              'Accept': 'application/json',      // Optional: menambahkan header Accept
            }
        ),);

      // Periksa status response
      if (response.statusCode == 200 && response.data['success'] == true) {
        print('Status transaksi berhasil diperbarui.');
        // Update data transaksi di aplikasi (jika perlu)

        return true; // Kembalikan true jika sukses
      } else {
        print(
            'Gagal memperbarui status transaksi: ${response.data["message"]}');
        return false; // Kembalikan false jika gagal
      }
    } catch (e) {
      print('Error updating transaction status: $e');
      return false; // Kembalikan false jika ada error
    } finally {
      loadingUpdateStatus.value = false;
    }
  }
}
