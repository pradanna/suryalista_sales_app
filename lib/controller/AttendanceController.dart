import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:suryalita_sales_app/Components/BottomSheet/CustomErrorBottomSheet.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/CustomSuccessBottomSheet.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class AttendanceController extends GetxController {
  final dio.Dio _dio = dio.Dio();

  var scheduleData = {}.obs;
  var notyetvisitedData = {}.obs;
  var todayScheduleData = [].obs;

  var isLoading = true.obs;
  var isLoadingTodayList = true.obs;
  var errorMessage = ''.obs;

  //SUBMIT
  var statusResponse = ''.obs;
  var messageResponse = ''.obs;
  var isLoadingSubmit = true.obs;

//TAKING PHOTO
  var isLoadingTakingPhoto = false.obs;
  var capturedImage = Rx<File?>(null);
  var compressedFile = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchSchedule();
  }

  @override
  void onReady() {
    super.onReady();
    fetchTodaySchedule();
  }

  Future<void> fetchSchedule() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _dio.get('$baseURL/api/attendance/weekly-schedule',
          options: dio.Options(
            sendTimeout: Duration(milliseconds: 3000),
            receiveTimeout: Duration(milliseconds: 5000),
            headers: {
              'Authorization': 'Bearer ' + await getToken(), // JWT token Anda
            },
          ));
      scheduleData.value = response.data['data'];
      notyetvisitedData.value = response.data['pending-lastweek'];
      print(scheduleData.value.toString());
    } catch (e) {
      errorMessage.value = e.toString();
      print(errorMessage.value.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTodaySchedule() async {
    try {
      isLoadingTodayList.value = true;
      errorMessage.value = '';
      final response = await _dio.get('$baseURL/api/attendance/today-schedule',
          options: dio.Options(
            // sendTimeout: Duration(milliseconds: 3000),
            // receiveTimeout: Duration(milliseconds: 5000),
            headers: {
              'Authorization': 'Bearer ' + await getToken(), // JWT token Anda
            },
          ));
      todayScheduleData.value = response.data['data'];
      print("todayScheduleData $todayScheduleData");
    } catch (e) {
      errorMessage.value = e.toString();
      print(errorMessage.value.toString());
    } finally {
      isLoadingTodayList.value = false;
    }
  }

  Future<void> submitAttendance({
    required BuildContext context,
    required String routeId,
    required String date,
    required String status,
    String? reason,
    File? image,
  }) async {
    final currentContext = context;
    isLoadingSubmit(true); // Menampilkan loading ketika proses API dimulai
    showCustomSuccessBottomSheet(
        context: currentContext,
        successType: 'loading'); // Menampilkan bottom sheet saat loading

    const url = '$baseURL/api/attendance/store'; // Ganti dengan URL API Anda

    // Data yang akan dikirimkan ke API
    dio.FormData formData = dio.FormData.fromMap({
      'route_id': routeId,
      'date': date,
      'status': status,
      'reason': reason ?? '',
      if (image != null) 'image': await dio.MultipartFile.fromFile(image.path),
      // Jika tidak ada reason, dikirimkan kosong
    });

    print("data $formData");
    try {
      // Mengirim permintaan POST ke API dengan Dio
      final response = await _dio.post(
        url,
        data: formData,
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getToken()}',
            // Anda bisa menambahkan header lain seperti token di sini jika diperlukan
          },
        ),
      );

      print("statusCode ${response.statusCode}");
      // Cek status code dari response
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = response.data;
        statusResponse.value = jsonResponse['status'];
        messageResponse.value = jsonResponse['message'];

        compressedFile.value = null;
        capturedImage.value = null;

        fetchSchedule();
        fetchTodaySchedule();
        Get.back();

        if (currentContext.mounted) {
          showCustomSuccessBottomSheet(
              context: currentContext,
              successType: "upload_success",
              delay: 1000,
              onDismissed: () {
                Get.back();
              });
        }
      } else {
        // Jika terjadi error di server
        statusResponse.value = 'failed';
        messageResponse.value =
            'Failed to submit attendance. Please try again.';
        print(messageResponse);
        Get.back();
        if (currentContext.mounted) {
          showCustomErrorBottomSheet(
              context: currentContext, errorType: "server_error");
        }
      }
    } catch (e) {
      // Error jika gagal koneksi atau ada kesalahan lain
      statusResponse.value = 'failed';
      messageResponse.value = 'Error: $e';
      Get.back();
      if (currentContext.mounted) {
        showCustomErrorBottomSheet(
            context: currentContext, errorType: "server_error");
      }
      print(messageResponse);
    } finally {
      isLoadingSubmit(false);
    }
  }

  Future<void> takePhoto() async {
    isLoadingTakingPhoto.value = true;

    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (photo != null) {
      File file = File(photo.path);

      // Membaca gambar ke dalam bentuk img.Image
      img.Image? image = img.decodeImage(file.readAsBytesSync());

      if (image != null) {
        // Mengompres gambar (opsional: ubah kualitas 70% untuk kompresi)
        img.Image compressedImage =
            img.copyResize(image, width: 800); // Menyesuaikan ukuran
        List<int> compressedBytes =
            img.encodeJpg(compressedImage, quality: 70); // Kualitas kompresi

        // Menyimpan file gambar yang telah terkompresi
        compressedFile.value = File('${photo.path}_compressed.jpg')
          ..writeAsBytesSync(compressedBytes);
        capturedImage.value = File(photo.path);
        // Anda bisa menggunakan compressedFile untuk diupload atau disimpan
      }
    }
    isLoadingTakingPhoto.value = false;
  }
}
