import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbarError(String title, String message, {bool isError = false}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: isError ? Colors.red.withOpacity(0.9) : Colors.black.withOpacity(0.9),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: EdgeInsets.all(10),
    borderRadius: 8,
    duration: Duration(seconds: 3),
    overlayColor: Colors.black.withOpacity(1), // optional overlay for added contrast
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  );
}
