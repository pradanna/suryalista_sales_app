import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../apiRequest/apiServices.dart';

class ProfileController extends GetxController {
  var email = ''.obs;
  var fullName = ''.obs;
  var username = ''.obs;
  var phoneNumber = ''.obs;
  var isLoading = false.obs;
  GetStorage box = GetStorage();
  Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();

  }


  Future<void> getProfile() async {
    final token = await box.read('token');
    if (token == null) {
      Get.snackbar('Error', 'No token found');
      return;
    }

    isLoading(true);
    try {
      final response = await _dio.get(
        baseURL+'/api/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Store profile data

        email.value = response.data['data']['email'];
        username.value = response.data['data']['username'];
        fullName.value = response.data['data']['name'];
        phoneNumber.value = response.data['data']['phone'];

      } else {
        Get.snackbar('Error', 'Failed to fetch profile data');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching profile data');
    } finally {
      isLoading(false);
    }
  }
}
