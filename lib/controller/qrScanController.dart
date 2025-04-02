import 'package:get/get.dart';

class QRScannerController extends GetxController {
  // Variabel untuk menyimpan hasil scan
  var scannedData = ''.obs;
  var isFlashOn = false.obs;
  var isProcessing = false.obs;
  // Mengupdate hasil scan
  void updateScannedData(String data) {
    scannedData.value = data;
  }

  // Mengontrol flash
  void toggleFlash() {
    isFlashOn.value = !isFlashOn.value;
  }
}
