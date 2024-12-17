import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/controller/AbsensiController.dart';

class AbsensiPage extends StatelessWidget {
  final AbsensiController controller = Get.put(AbsensiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Absensi Toko'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Saat ini kamu sedang berada di",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Obx(() => Text(
              controller.storeName.value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900]),
            )),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Alamat", style: TextStyle(fontWeight: FontWeight.bold)),
                    Obx(() => Text(controller.storeAddress.value)),
                  ],
                ),
              ],
            ),
            Divider(thickness: 1, height: 30),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("No. Phone", style: TextStyle(fontWeight: FontWeight.bold)),
                    Obx(() => Text(controller.storePhone.value)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Tekan tombol konfirmasi absensi di bawah ini jika sesuai",
              style: TextStyle(fontSize: 14),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.confirmAbsensi,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.teal,
                ),
                child: Text(
                  "Konfirmasi Absensi Toko",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
