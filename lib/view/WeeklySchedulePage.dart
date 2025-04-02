import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/CustomErrorBottomSheet.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/controller/AttendanceController.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeeklySchedulePage extends StatelessWidget {
  final AttendanceController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 0,
        title: Text('Weekly Schedule'),
      ),
      body: Container(
        color: Colorsmaster.backgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Jadwal Mingguan
              Obx(() {
                if (_controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (_controller.errorMessage.value.isNotEmpty) {
                  return Center(
                      child: Text('Error: ${_controller.errorMessage.value}'));
                }

                if (_controller.scheduleData.isEmpty) {
                  return Center(child: Text('No schedule found.'));
                }

                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: _controller.scheduleData.keys.map((date) {
                    final items = _controller.scheduleData[date] as List;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header untuk tanggal
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 8.h),
                          child: Text(
                            formatDatedMMMMYYYY(date),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // Daftar item untuk tanggal tersebut
                        ...items.map((item) {
                          final customer = item['customer'];
                          final status = item['status'];
                          final canopen = item['canopen'];

                          return InkWell(
                            onTap: !canopen
                                ? () {
                                    showCustomErrorBottomSheet(
                                        context: context,
                                        errorType: "notindate");
                                  }
                                : status == "Pending"
                                    ? () {
                                        Get.toNamed("/absenpage", arguments: {
                                          'route_id': item['id'],
                                          'date': date,
                                          'name': customer['name'],
                                          'address': customer['address'],
                                          'phone': customer['phone'],
                                          'status': status
                                        });
                                      }
                                    : () {
                                        Get.toNamed("/absendetailpage",
                                            arguments: {
                                              'name': customer['name'],
                                              'address': customer['address'],
                                              'phone': customer['phone'],
                                              'status': status,
                                              'date': item['attendance_date'],
                                              'absensi_datetime':
                                                  item['attendance_time'],
                                              'alasan':
                                                  item['attendance_reason'],
                                              'image_path':
                                                  item['attendance_image'],
                                            });
                                      },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(10.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40.w,
                                      height: 40.w,
                                      child: CircleAvatar(
                                        child: Text(
                                            customer['name'][0].toUpperCase()),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            customer['name'],
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            customer['address'],
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: status == 'Dikunjungi'
                                            ? Colors.green
                                            : status == 'Pending'
                                                ? Colors.orange
                                                : Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        SizedBox(height: 20.h),
                      ],
                    );
                  }).toList(),
                );
              }),

              // Bagian Not Yet Visited
              Obx(() {
                if (_controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (_controller.errorMessage.value.isNotEmpty) {
                  return Center(
                      child: Text('Error: ${_controller.errorMessage.value}'));
                }

                if (_controller.notyetvisitedData.isEmpty) {
                  return Center(child: Text('No pending schedules.'));
                }

                return Container(
                  color: Colors.pink[50], // Background merah muda
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                        "Jadwal sudah terlewat",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      Text(
                        "dan belum ada kunjungan",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children:
                            _controller.notyetvisitedData.keys.map((date) {
                          final items =
                              _controller.notyetvisitedData[date] as List;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header untuk tanggal
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 8.h),
                                child: Text(
                                  formatDatedMMMMYYYY(date),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              // Daftar item untuk tanggal tersebut
                              ...items.map((item) {
                                final customer = item['customer'];
                                final status = item['status'];

                                return InkWell(
                                  onTap: status == "Pending"
                                      ? () {
                                          Get.toNamed("/absenpageterlewat",
                                              arguments: {
                                                'route_id': item['id'],
                                                'date': date,
                                                'name': customer['name'],
                                                'address': customer['address'],
                                                'phone': customer['phone'],
                                                'status': status
                                              });
                                        }
                                      : () {
                                          Get.toNamed("/absendetailpage",
                                              arguments: {
                                                'name': customer['name'],
                                                'address': customer['address'],
                                                'phone': customer['phone'],
                                                'status': status,
                                                'date': item['attendance_date'],
                                                'absensi_datetime':
                                                    item['attendance_time'],
                                                'alasan':
                                                    item['attendance_reason'],
                                                'image_path':
                                                    item['attendance_image'],
                                              });
                                        },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(10.w),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40.w,
                                            height: 40.w,
                                            child: CircleAvatar(
                                              child: Text(customer['name'][0]
                                                  .toUpperCase()),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  customer['name'],
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  customer['address'],
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 5.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: status == 'Dikunjungi'
                                                  ? Colors.green
                                                  : status == 'Pending'
                                                      ? Colors.orange
                                                      : Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              SizedBox(height: 20.h),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
