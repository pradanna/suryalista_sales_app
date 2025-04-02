import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/CustomErrorBottomSheet.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/controller/qrScanController.dart';

class QRScannerPage extends StatelessWidget {
  final args = Get.arguments;
  final QRScannerController controller = Get.put(QRScannerController());
  DateTime now = DateTime.now();
   // Tambahkan variabel untuk mencegah duplikasi

  @override
  Widget build(BuildContext context) {
    final String? id = args?['id'];

    print(id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Toko'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                controller.isFlashOn.value ? Icons.flash_on : Icons.flash_off)),
            onPressed: () {
              controller.toggleFlash();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Layer pertama: Kamera untuk scanning
        MobileScanner(
        fit: BoxFit.cover,
        onDetect: (barcodeCapture) async {
          if (controller.isProcessing.value) return; // Cegah eksekusi jika masih dalam proses

          controller.isProcessing.value = true;  // Tandai proses sedang berjalan
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              controller.updateScannedData(code);

              if (id != null) {
                if (id == code) {
                  showCustomErrorBottomSheet(
                    context: context,
                    errorType: 'wrongusernameorpassword',
                  );
                } else {
                  Get.toNamed("/absenpage", arguments: {
                    'route_id': code,
                    'date': formatDate(now),
                  });
                }
              } else {
                Get.toNamed("/absenpage", arguments: {
                  'route_id': code,
                  'date': formatDate(now),
                });
              }
            }
          }

          await Future.delayed(Duration(seconds: 3));  // Tambahkan delay 5 detik
          controller.isProcessing.value = false;  // Reset proses setelah delay
        },
      ),

          Center(
            child: Obx(() => Container(
                width: 250, // Sesuaikan ukuran kotak panduan
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.isProcessing.value ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.isProcessing.value ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ))
            ),

          // Layer ketiga: Tampilkan hasil scan
          // Obx(() => Positioned(
          //       bottom: 30,
          //       left: 0,
          //       right: 0,
          //       child: Center(
          //         child: Text(
          //           'Scanned Data: ${controller.scannedData.value}',
          //           style: TextStyle(
          //               fontSize: 18,
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //     )),
        ],
      ),
    );
  }
}
