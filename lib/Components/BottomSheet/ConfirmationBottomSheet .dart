import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmationBottomSheet {
  static void show({
    required String title,
    required String subtitle,
    String? imagePath,
    VoidCallback? onYes,
    VoidCallback? onNo,
    String textFieldLabel = "",
    Function(String)? onTextChanged,
  }) {
    final TextEditingController textController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            imagePath == null
                ? Container()
                : Image.asset(
                    imagePath,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            if (textFieldLabel != "") ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    labelText: 'Masukan Alasan', // Label untuk TextField
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[200]!,
                        // Warna border saat tidak aktif
                        width: 2.0,
                      ),
                      borderRadius:
                          BorderRadius.circular(10.0), // Radius border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colorsmaster.primaryColor,
                        // Warna border saat aktif
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: onTextChanged,
                ),
              ),
            ],
            Divider(
              color: Colors.grey[100],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onNo ?? Get.back,
                    child: const Text("Tidak"),
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                SizedBox(
                  width: 16.w,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colorsmaster.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onYes ?? Get.back,
                    child: const Text("Ya"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isDismissible: true,
    );
  }
}
