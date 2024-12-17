import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/list/listDaftarKunjungan.dart';
import 'package:suryalita_sales_app/Components/list/listKategoriWidget.dart';
import 'package:suryalita_sales_app/controller/categoryController.dart';
import 'package:suryalita_sales_app/controller/homeController.dart';
import '../Components/color/colorsMaster.dart';

class Homeview extends StatelessWidget {
  final HomeController homeController = Get.find();
  final CategoryController categoryController = Get.find();

  @override
  Widget build(BuildContext context) {
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
                child: Obx(() => CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${homeController.cartItemCount}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () {
              Get.toNamed('scanqr');
              // Tindakan untuk scan barcode
              // Get.snackbar("Scan Barcode", "Tombol scan barcode ditekan");
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        color: Colorsmaster.backgroundColor,
        height: 1.sh,
        child: SingleChildScrollView(
            child: Column(
          children: [
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
                  Container(
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
                      padding: EdgeInsets.all(10.w),
                      // Padding agar tidak terlalu mepet
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon Time Limit
                            Icon(
                              Icons.timelapse_outlined,
                              // Icon Material time_limit
                              color: Colors.white,
                              size: 40.sp, // Ukuran responsif
                            ),
                            SizedBox(height: 10.h),
                            // Jarak vertikal
                            // Text Sisa Target
                            Text(
                              'Sisa Target',
                              style: TextStyle(
                                fontSize: 14.sp,
                                // Ukuran teks responsif
                                color: Colors.white,
                              ),
                            ),
                            // Nominal Sisa Target
                            Text(
                              '50.000.000',
                              style: TextStyle(
                                fontSize: 16.sp,
                                // Ukuran teks responsif
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            // Jarak vertikal dengan margin 30.h
                            // Container untuk persentase pencapaian
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // Warna latar pills
                                borderRadius:
                                    BorderRadius.circular(20), // Radius pill
                              ),
                              child: Text(
                                '75% Dari Target',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    // Ukuran teks responsif
                                    color: Colorsmaster.dangerColor,
                                    fontWeight:
                                        FontWeight.bold // Warna teks hitam
                                    ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      'Rp 50.000.000',
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
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Icon Time Limit di sebelah kiri
                                Icon(
                                  Icons.payments,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text Sisa Target
                                    Text(
                                      'Penjualan',
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
                                      'Rp 50.000.000',
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
                        )
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
            Obx(() {
              return KategoriProdukWidget(
                categories: categoryController.categories.value,
                isLoading: categoryController.isLoading.value,
              );
            }),
            SizedBox(
              height: 10.h,
            ),
            JadwalKunjunganWidget()
          ],
        )),
      ),
    );
  }
}
