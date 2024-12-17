import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  void login() async {

    isLoading(true);

    var formData = dio.FormData.fromMap({'username': username.value,
      'password': password.value,});

    try {
      final response = await _dio.post(
        baseURL+'/api/login',
        data: formData, options: dio.Options(headers: {'Accept': 'application/json'})
      );

      if (response.statusCode == 200) {

        await box.write('token', response.data['data']['access_token']);

        Get.offAllNamed('/base');
      } else {
        showSnackbarError('Login Gagal', 'Username atau password salah. Silakan periksa kembali, jika ada masalah lebih lanjut silahkan hubungi admin', isError: true);
      }
    } catch (e) {
      showSnackbarError('Login Gagal', 'Terjadi kesalahan. Silakan periksa kembali, jika ada masalah lebih lanjut silahkan hubungi admin', isError: true);
      print(e);
    } finally {
      isLoading(false);
    }
  }

// Fungsi untuk membuka link WhatsApp
  Future<void> contactAdmin() async {
    const String adminPhone = "6281241939160";
    final Uri whatsappUrl = Uri.parse("https://wa.me/$adminPhone?text=Halo%20Admin,%20saya%20mengalami%20masalah%20saat%20login.");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }
}
