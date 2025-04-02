import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:suryalita_sales_app/Components/BottomSheet/ConfirmationBottomSheet%20.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/CustomErrorBottomSheet.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/controller/AttendanceController.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AbsensiPage extends StatefulWidget {
  @override
  _AbsensiPageState createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  final AttendanceController controller = Get.find();
  final args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final name = args['name'];
    final address = args['address'];
    final phone = args['phone'];
    final status = args['status'];
    final String route_id = args['route_id'];
    final date = args['date'];
    String? alasan;

    print(route_id);
    print("date $date");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text('Absensi Toko'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          // Border radius 10
                          border: Border.all(
                            color: Colors.grey[200]!, // Warna border grey[200]
                            width: 1, // Lebar border
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Saat ini kamu sedang berada di",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey),
                            ),
                            SizedBox(height: 5),
                            Text(
                              name,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colorsmaster.primaryColor),
                            ),
                            Divider(
                              thickness: 1,
                              height: 30,
                              color: Colors.grey[100],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colorsmaster.primaryColor),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Alamat",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(address,
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              height: 30,
                              color: Colors.grey[100],
                            ),
                            Row(
                              children: [
                                Icon(Icons.phone,
                                    color: Colorsmaster.primaryColor),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("No. Phone",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      phone,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Ambil foto toko sebagai bukti kehadiran:",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                      Obx(() {
                        print(controller.isLoadingTakingPhoto.value.toString());
                        return controller.isLoadingTakingPhoto.value
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Colorsmaster.primaryColor,
                              ))
                            : Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: controller.compressedFile.value !=
                                              null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                controller
                                                    .compressedFile.value!,
                                                height: 200,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                "Foto belum diambil",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                            ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: TextButton.icon(
                                        onPressed: controller.takePhoto,
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: 20.sp,
                                        ),
                                        label: Text(
                                          "Ambil Foto",
                                          style: TextStyle(fontSize: 10.sp),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          backgroundColor:
                                              Colorsmaster.primaryColor,
                                          foregroundColor: Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      }),
                      SizedBox(height: 30),
                      Text(
                        "Tekan tombol konfirmasi absensi di bawah ini jika sudah sesuai",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              status != "Pending"
                  ? Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: Text("Kamu sudah melakukan absensi di Toko ini"),
                      ))
                  : Column(
                      children: [
                        Divider(
                          color: Colors.grey[200],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    alasan = "";

                                    ConfirmationBottomSheet.show(
                                      title: "Tidak ada kunjungan di Toko ini",
                                      subtitle:
                                          "Tolong berikan alasan kenapa tidak ada kunjungan?",
                                      // imagePath: "assets/images/confirmation.png",
                                      textFieldLabel: "Masukan Alasan",
                                      onTextChanged: (val) {
                                        alasan = val;
                                      },
                                      onYes: () {
                                        if (alasan == null || alasan == "") {
                                          // Validasi jika alasan kosong
                                          Get.snackbar(
                                            "Error",
                                            "Alasan harus diisi",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.redAccent,
                                            colorText: Colors.white,
                                          );
                                        } else {
                                          Get.back();

                                          controller.submitAttendance(
                                              routeId: route_id,
                                              date: date,
                                              status: "Dilewatkan",
                                              reason: alasan,
                                              context: context);
                                          // Menutup dialog
                                        }
                                      },
                                      onNo: () {
                                        Get.back(); // Menutup BottomSheet
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.redAccent),
                                  child: Text(
                                    "Tidak Dikunjungi",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              Expanded(child: Obx(() {
                                return ElevatedButton(
                                  onPressed:
                                      controller.capturedImage.value == null
                                          ? () {
                                              showCustomErrorBottomSheet(
                                                  context: context,
                                                  errorType: 'belumadafoto');
                                            }
                                          : () {
                                              ConfirmationBottomSheet.show(
                                                title: "Konfirmasi",
                                                subtitle:
                                                    "Apakah Anda yakin ingin melanjutkan aksi ini?",
                                                imagePath:
                                                    "assets/images/confirmation.jpeg",
                                                onYes: () {
                                                  Get.back();

                                                  controller.submitAttendance(
                                                      routeId: route_id,
                                                      date: date,
                                                      status: "Dikunjungi",
                                                      context: context,
                                                      image: controller
                                                          .compressedFile
                                                          .value);
                                                },
                                                onNo: () {
                                                  Get.back(); // Menutup BottomSheet
                                                },
                                              );
                                            },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor:
                                        controller.capturedImage.value == null
                                            ? Colors.grey
                                            : Colorsmaster.primaryColor,
                                  ),
                                  child: Text(
                                    "Konfirmasi Absensi",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                );
                              })),
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
