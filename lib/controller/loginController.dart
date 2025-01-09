import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/CustomErrorBottomSheet.dart';
import 'package:suryalita_sales_app/Components/snackbar/showSnackbar.dart';

import 'package:url_launcher/url_launcher.dart';
import '../apiRequest/apiServices.dart';

class LoginController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  dio.Dio _dio = dio.Dio();
  final GetStorage box = GetStorage();

  void login(context) async {
    isLoading(true);
    print("0");
    var formData = dio.FormData.fromMap({
      'username': username.value,
      'password': password.value,
    });

    try {
      final response = await _dio.post(
        baseURL + '/api/auth/login',
        data: formData,
        options: dio.Options(headers: {'Accept': 'application/json'}),
      );

      print("1");
      if (response.statusCode == 200) {
        await box.write('token_litasurya', response.data['access_token']);
        await box.write('userid_litasurya', response.data['user_id']['id']);
        Get.offAllNamed('/base');
        print("2");
      } else if (response.statusCode == 401) {
        print("3");
        showSnackbarError(response.data['message'],
            'Username atau password salah. Silakan coba lagi.',
            isError: true);
      } else {
        showSnackbarError(
            'Login Gagal', 'Terjadi kesalahan. Silakan coba lagi.',
            isError: true);
      }
    } catch (e) {
      if (e is dio.DioException) {
        print("DioError: ${e.response?.data ?? e.message}");  // Menampilkan detail kesalahan Dio
        showCustomErrorBottomSheet(context: context, errorType: 'wrongusernameorpassword');
        // Menunda eksekusi selama 1 detik
        await Future.delayed(Duration(seconds: 2));

        // Memanggil Get.back() setelah 1 detik
        Get.back();
      } else {
        print("Error: $e");
        showSnackbarError('Login Gagal',
            'Terjadi kesalahan. Silakan periksa kembali, jika ada masalah lebih lanjut silahkan hubungi admin',
            isError: true);
      }

    }finally{
      isLoading(false);
    }

  }

// Fungsi untuk membuka link WhatsApp
  Future<void> contactAdmin() async {
    const String adminPhone = "6281241939160";
    final Uri whatsappUrl = Uri.parse(
        "https://wa.me/$adminPhone?text=Halo%20Admin,%20saya%20mengalami%20masalah%20saat%20login.");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  Future<void> logout() async {
    try {
      // Mendapatkan instance GetStorage

      // Menghapus token dari GetStorage
      await box.remove('token_litasurya');  // Menghapus token yang disimpan

      // Navigasi kembali ke halaman login setelah logout
      Get.offAllNamed('/login');  // Ganti '/login' dengan route halaman login Anda
    } catch (e) {
      // Jika terjadi kesalahan saat logout
      print('Logout gagal: $e');
    }
  }
}
