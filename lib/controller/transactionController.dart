// lib/controllers/transaction_controller.dart
import 'package:get/get.dart';
import 'package:suryalita_sales_app/model/Transaction.dart';
import 'package:suryalita_sales_app/services/transactionService.dart';

class TransactionController extends GetxController {
  final TransactionService _transactionService = TransactionService();
  var transactions = <Transaction>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isEmpty = false.obs;

  Future<void> fetchTransactions({bool reset = false, String search = ''}) async {
    if (isLoading.value || isLoadingMore.value) return;

    if (reset) {
      isLoading.value = true;
      currentPage.value = 1;
      totalPages.value = 1;
      transactions.clear();
      isEmpty.value = false;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final data = await _transactionService.fetchTransactions(
        search: search,
        page: currentPage.value,
      );

      final List<Transaction> fetchedTransactions = (data['data'] as List)
          .map((json) => Transaction.fromJson(json))
          .toList();

      transactions.addAll(fetchedTransactions);
      totalPages.value = data['last_page'];

      if (transactions.isEmpty) {
        isEmpty.value = true;
      } else {
        isEmpty.value = false;
      }

      currentPage.value += 1;
    } catch (e) {
      print('Error fetching transactions: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
