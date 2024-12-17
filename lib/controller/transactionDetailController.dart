import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/model/Transaction.dart';

class TransactionDetailController extends GetxController {
  final Dio _dio = Dio();
  var transaction = Rxn<Transaction>();
  var isLoading = false.obs;

  Future<void> fetchTransactionDetail(String id) async {
    isLoading.value = true;
    try {
      final response = await _dio.get('$baseURL/api/transaction/$id');
      print("test Response" + response.data["carts"][0]["item"].toString());
      transaction.value = Transaction.fromJson(response.data);
    } catch (e) {
      print('Error fetching transaction detail: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
