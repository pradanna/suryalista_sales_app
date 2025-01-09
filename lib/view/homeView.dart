import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/Components/list/listDaftarKunjungan.dart';
import 'package:suryalita_sales_app/Components/list/listKategoriWidget.dart';
import 'package:suryalita_sales_app/controller/AttendanceController.dart';
import 'package:suryalita_sales_app/controller/categoryController.dart';
import 'package:suryalita_sales_app/controller/homeController.dart';
import 'package:suryalita_sales_app/controller/loginController.dart';
import '../Components/color/colorsMaster.dart';

class Homeview extends StatelessWidget {
  final HomeController homeController = Get.find();
  final CategoryController categoryController = Get.find();
  final AttendanceController attendanceController = Get.find();
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    categoryController.fetchCategories(context);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colorsmaster.backgroundColor,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0), // Tinggi garis bawah
            child: Container(
              color: Colors.grey[300], // Warna garis bawah
              height: 1.0, // Ketebalan garis bawah
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo,',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Obx(() => Text(
                    homeController.userName.value,
                    style: TextStyle(fontSize: 18),
                  )),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Tindakan untuk pencarian
                Get.toNamed(
                  'search',
                  arguments: {
                    'categoryId': null,
                  },
                );
              },
            ),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Tindakan untuk keranjang
                    Get.toNamed('cart');
                  },
                ),
                Positioned(
                    right: 0,
                    child: Obx(() => homeController.cartItemCount.value == 0
                        ? Container()
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Text(
                              '${homeController.cartItemCount}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ))),
              ],
            ),

          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            color: Colorsmaster.backgroundColor,
            height: 1.sh,
            child: RefreshIndicator(
              onRefresh: () async {
                categoryController.fetchCategories(context);
                homeController.updateCartItemCount();
                homeController.fetchDailyTarget();
                homeController.fetchTotalTransactionsToday();
              },
              child: SingleChildScrollView(
                child: Column(children: [
                  // TOP Section

                  const Row(
                    children: [
                      Column(
                        children: [Text("Halo,"), Text("Bagus Yanuar")],
                      )
                    ],
                  ),
                  // Target Section
                  Container(
                    margin: EdgeInsets.only(top: 50.h),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Obx(() => homeController.isLoadingTagetAmount.value
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.grey,
                                  width: 120.w,
                                  height: 180.h, // Tinggi lingkaran
                                ),
                              )
                            : Container(
                                width: 120.w,
                                height: 180.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  // Radius 5
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    // Mulai dari kiri atas
                                    end: Alignment.bottomRight,
                                    // Berakhir di kanan bawah
                                    colors: [
                                      Color(0xFF973131), // Warna #973131
                                      Color(0xFFF9D689), // Warna #F9D689
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    10.w,
                                  ),
                                  // Padding agar tidak terlalu mepet
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Icon Time Limit

                                        Icon(
                                          Icons.payments,
                                          // Icon Material time_limit
                                          color: Colors.white,
                                          size: 40
                                              .sp, // Ukuran responsif lebih besar untuk landscape
                                        ),
                                        SizedBox(height: 10.h),
                                        // Jarak vertikal
                                        // Text Sisa Target
                                        Text(
                                          'Penjualan',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            // Ukuran teks responsif
                                            color: Colors.white,
                                          ),
                                        ),
                                        // Nominal Sisa Target
                                        Text(
                                          formatRupiahInt(homeController
                                                  .totalTransaction.value)
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            // Ukuran teks responsif
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),

                                        SizedBox(height: 30.h),

                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 5.h),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            // Warna latar pills
                                            borderRadius: BorderRadius.circular(
                                                20), // Radius pill
                                          ),
                                          child: Text(
                                            calculatePercentage(
                                                        homeController
                                                            .totalTransaction
                                                            .value,
                                                        homeController
                                                            .targetAmount.value)
                                                    .toString() +
                                                '% dari Target',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                // Ukuran teks responsif
                                                color: Colorsmaster.dangerColor,
                                                fontWeight: FontWeight
                                                    .bold // Warna teks hitam
                                                ),
                                          ),
                                        ),
                                      ]),
                                ),
                              )),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Obx(() => homeController
                                      .isLoadingTagetAmount.value
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        color: Colors.grey,
                                        height: 90.w, // Tinggi lingkaran
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      // Lebar untuk mode landscape
                                      height: 90.w,
                                      // Tinggi untuk mode landscape
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        // Radius 5
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF6439FF), // Warna #973131
                                            Color(0xFF7CF5FF), // Warna #F9D689
                                          ],
                                        ), // Penutup BoxDecoration
                                      ),
                                      // Penutup Container Decoration
                                      child: Padding(
                                        padding: EdgeInsets.all(10.w),
                                        // Padding agar tidak terlalu mepet
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Icon Time Limit di sebelah kiri
                                            Icon(
                                              Icons.adjust,
                                              // Icon Material time_limit
                                              color: Colors.white,
                                              size: 40
                                                  .sp, // Ukuran responsif lebih besar untuk landscape
                                            ),
                                            // Penutup Icon
                                            SizedBox(width: 20.w),
                                            // Jarak horizontal antara icon dan text
                                            // Column untuk menampung teks dan nominal
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Text Sisa Target
                                                Text(
                                                  'Target Hari ini',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    // Ukuran teks responsif
                                                    color: Colors.white,
                                                  ), // Penutup TextStyle
                                                ),
                                                // Penutup Text Sisa Target
                                                SizedBox(height: 5.h),
                                                // Jarak vertikal
                                                // Nominal Sisa Target
                                                Text(
                                                  formatRupiahInt(homeController
                                                      .targetAmount.value),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    // Ukuran teks responsif lebih besar
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ), // Penutup TextStyle
                                                ),
                                                // Penutup Text Nominal
                                              ], // Penutup Column Children
                                            ),
                                            // Penutup Column
                                          ], // Penutup Row Children
                                        ), // Penutup Row
                                      ), // Penutup Padding
                                    )),
                              SizedBox(
                                height: 20,
                              ),
                              Obx(() => homeController
                                      .isLoadingSumTotalToday.value
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        color: Colors.grey,
                                        height: 90.w, // Tinggi lingkaran
                                      ),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      // Lebar untuk mode landscape
                                      height: 90.w,
                                      // Tinggi untuk mode landscape
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        // Radius 5
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF402E7A), // Warna #973131
                                            Color(0xFF3DC2EC), // Warna #F9D689
                                          ],
                                        ), // Penutup BoxDecoration
                                      ),
                                      // Penutup Container Decoration
                                      child: Padding(
                                        padding: EdgeInsets.all(10.w),
                                        // Padding agar tidak terlalu mepet
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Icon Time Limit di sebelah kiri
                                            Icon(
                                              Icons.timelapse_outlined,
                                              // Icon Material time_limit
                                              color: Colors.white,
                                              size: 40.sp, // Ukuran responsif
                                            ),
                                            // Penutup Icon
                                            SizedBox(width: 20.w),
                                            // Jarak horizontal antara icon dan text
                                            // Column untuk menampung teks dan nominal
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Text Sisa Target
                                                Text(
                                                  'Sisa Target',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    // Ukuran teks responsif
                                                    color: Colors.white,
                                                  ), // Penutup TextStyle
                                                ),
                                                // Penutup Text Sisa Target
                                                SizedBox(height: 5.h),
                                                // Jarak vertikal
                                                // Nominal Sisa Target
                                                Text(
                                                  formatRupiahInt(homeController
                                                          .targetAmount.value -
                                                      homeController
                                                          .totalTransaction
                                                          .value),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    // Ukuran teks responsif lebih besar
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ), // Penutup TextStyle
                                                ),
                                                // Penutup Text Nominal
                                              ], // Penutup Column Children
                                            ),
                                            // Penutup Column
                                          ], // Penutup Row Children
                                        ), // Penutup Row
                                      ), // Penutup Padding
                                    )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  // PRODUK TOKO SECTION
                  SizedBox(
                    height: 10.h,
                  ),
                  Obx(() => KategoriProdukWidget(
                        categories: categoryController.categories.value,
                        isLoading: categoryController.isLoading.value,
                      )),
                  SizedBox(
                    height: 10.h,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Jadwal Kunjungan Hari ini",
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 8.h,
                      ),
                      Obx(() {
                        if (attendanceController.isLoadingTodayList.value) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (attendanceController
                            .errorMessage.value.isNotEmpty) {
                          return Center(
                              child: Text(
                                  'Error: ${attendanceController.errorMessage.value}'));
                        }

                        if (attendanceController.todayScheduleData.isEmpty) {
                          return Center(child: Column(
                            children: [
                              SizedBox(height: 20.h,),
                              Text('Tidak ada jadwal kunjungan untuk hari ini.', style: TextStyle(color: Colors.grey, fontSize: 12.sp),),
                            ],
                          ));
                        }
                        return Column(
                          children: attendanceController.todayScheduleData
                              .map<Widget>((item) {
                            final customer = item['customer'];
                            final status = item['status'];

                            return InkWell(
                                onTap: status == "Pending"
                                    ? () {
                                        Get.toNamed("/absenpage", arguments: {
                                          'route_id': item['id'],
                                          'date': formatDate(now),
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
                                              'absensi_datetime': item['attendance_time'],
                                              'alasan': item['attendance_reason'],
                                              'image_path': item['attendance_image'],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40.w,
                                          height: 40.w,
                                          child: CircleAvatar(
                                            child: Text(customer['name'][0]
                                                .toUpperCase()), // Initial of the name
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
                                                // Customer's name
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                customer['address'],
                                                // Customer's address
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              Text(
                                                'Phone: ${customer['phone']}',
                                                // Customer's phone number
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
                                              horizontal: 12.w, vertical: 5.h),
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
                                            status, // Status of the visit
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
                                ));
                          }).toList(),
                        );
                      }),
                    ],
                  )
                ]),
              ),
            )));
  }
}
