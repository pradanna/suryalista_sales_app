import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suryalita_sales_app/Components/helper/dBhelper.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';

class HomeController extends GetxController {
  DBHelper dbHelper = DBHelper();
  final Dio _dio = Dio();
  final GetStorage box = GetStorage();

  var userName = "".obs; // Contoh nama pengguna
  var userid = "".obs; // Contoh nama pengguna
  var cartItemCount = 0.obs;

  var targetAmount = 0.obs;
  var totalTransaction = 0.obs;
  var isLoadingTagetAmount = false.obs;
  var isLoadingSumTotalToday = false.obs;

  Future<void> updateCartItemCount() async {
    final totalQty = await dbHelper.getTotalQty();
    cartItemCount.value = totalQty;
  }

  Future<bool> fetchDailyTarget() async {
    isLoadingTagetAmount.value = true;
    String token = await box.read('token_litasurya') ?? '';

    try {
      // Mengambil data target harian
      final response = await _dio.get('$baseURL/api/target-today',
        options: Options(
            headers: {
              'Authorization': 'Bearer $token',  // Menambahkan header Authorization
              'Accept': 'application/json',      // Optional: menambahkan header Accept
            }
        ),);

      // Mengecek apakah response berhasil
      if (response.statusCode == 200) {
        // Cek jika data target tersedia
        if (response.data['status'] == 'success' && response.data['data'] != null) {
          // Menyimpan data target jika perlu
          var targetData = response.data['data'];
          targetAmount.value = targetData['amount'];
          // Lakukan sesuatu dengan data target (misalnya menyimpannya ke variabel atau state)

          print("Target hari ini: ${targetData['amount']}");

          return true; // Return true jika sukses
        } else {
          print('Target hari ini tidak ditemukan');
          return false; // Return false jika target hari ini tidak ada
        }
      } else {
        print('Error: ${response.statusCode}');
        return false; // Return false jika terjadi error
      }
    } catch (e) {
      print('Error fetching target: $e');
      return false; // Return false jika terjadi exception
    }finally{
      isLoadingTagetAmount.value = false;
    }
  }

  Future<bool> fetchTotalTransactionsToday() async {
    isLoadingSumTotalToday.value = true;

    // Ambil token dari box (misalnya menggunakan GetStorage atau GetX)
    String token = await box.read('token_litasurya') ?? '';
    String userid = await box.read('userid_litasurya').toString() ?? '';

    try {
      final response = await _dio.get(
        '$baseURL/api/transactions/total/today/$userid',
        options: Options(
            headers: {
              'Authorization': 'Bearer $token',  // Menambahkan header Authorization
              'Accept': 'application/json',      // Optional: menambahkan header Accept
            }
        ),
      );

      if (response.statusCode == 200) {
        // Mengambil data dari response
        print("check1");
        var transactionData = response.data['data'];
        print("check2");
        totalTransaction.value = parseToInt(transactionData['total_transactions_today']);
        print("check3");

        // Menampilkan data transaksi
        print('Total Transaksi Hari Ini: ${transactionData['total_transactions_today']}');
        return true;
      } else {
        print('Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return false;
    } finally {
      isLoadingSumTotalToday.value = false;
    }
  }



  @override
  void onReady() {
    super.onReady();
    updateCartItemCount();
    fetchDailyTarget();
    fetchTotalTransactionsToday();
  }

}
