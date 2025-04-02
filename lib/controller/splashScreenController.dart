import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreenController extends GetxController {
  var count = 0;
  GetStorage box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    runsplash();
  }

  void runsplash() async {
    var token = await box.read("token_litasurya");

    print('token splash ' + token.toString());
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (token == null) {
        Get.offNamed("login");
        // Get.offNamed("/login");
      } else {
        Get.offNamed("base");
      }
    });
  }
}
