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

class AbsensiPageTerlewat extends StatefulWidget {
  @override
  _AbsensiPageState createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPageTerlewat> {
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
                              name,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colorsmaster.primaryColor),
                            ),
                            Text("absen di toko ini seharusnya dilakukan di tanggal $date", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
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
