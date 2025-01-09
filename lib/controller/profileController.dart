import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suryalita_sales_app/controller/homeController.dart';

import '../apiRequest/apiServices.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var username = ''.obs;
  var phoneNumber = Rxn<String>();
  var address = Rxn<String>();
  var photoUrl = Rxn<String>();
  var isLoading = false.obs;
  GetStorage box = GetStorage();
  Dio _dio = Dio();

  final HomeController homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }


  Future<void> getProfile() async {
    String token = await box.read('token_litasurya') ?? '';
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
              'Authorization': 'Bearer $token',  // Menambahkan header Authorization
              'Accept': 'application/json',      // Optional: menambahkan header Accept
            }
        ),);

      print("Response Profile "+response.data.toString());

      if (response.statusCode == 200) {
        // Store profile data

        username.value = response.data['data']['username'];
        name.value = response.data['data']['sales']['name'];
        phoneNumber.value = response.data['data']['sales']?['phone'];
        address.value = response.data['data']['sales']?['address'];
        photoUrl.value = response.data['data']['sales']?['photo'];

        homeController.userName.value = name.value;
        homeController.userid.value = response.data['data']['id'].toString();

        print("address ${address.value}");
        print("phoneNumber ${phoneNumber.value}");

      } else if (response.statusCode == 401) {
        Get.offAndToNamed("/login");
      }else {
        Get.snackbar('Error', 'Failed to fetch profile data');
      }
    } catch (e) {
      print("error Profile "+e.toString());
      Get.snackbar('Error', 'An error occurred while fetching profile data');
    } finally {
      isLoading(false);
    }
  }
}
