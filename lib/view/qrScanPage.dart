import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:suryalita_sales_app/controller/qrScanController.dart';

class QRScannerPage extends StatelessWidget {
  final QRScannerController controller = Get.put(QRScannerController());

  @override
  Widget build(BuildContext context) {
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
            onDetect: (barcodeCapture) {
              final List<Barcode> barcodes = barcodeCapture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  controller.updateScannedData(code);
                  Get.snackbar("QR Code Scanned", "Data: $code",
                      snackPosition: SnackPosition.BOTTOM);
                  Get.offAndToNamed("/absenpage");
                }
              }
            },
          ),

          Center(
            child: Container(
              width: 250, // Sesuaikan ukuran kotak panduan
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
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
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),

          // Layer ketiga: Tampilkan hasil scan
          Obx(() => Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Scanned Data: ${controller.scannedData.value}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
