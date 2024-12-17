import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/model/Category.dart';
import 'package:get/get.dart';

class KategoriProdukWidget extends StatelessWidget {
  final List<Category> categories;
  final bool isLoading;

  KategoriProdukWidget({required this.categories, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ScreenUtil

    return Padding(
      padding: EdgeInsets.all(10.w), // Padding umum
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul "Kategori Produk"
          Text(
            'Kategori Produk',
            style: TextStyle(
              fontSize: 14.sp, // Ukuran teks responsif
              fontWeight: FontWeight.bold,
            ),
          ), // Penutup Text Judul
          SizedBox(height: 12.h), // Jarak setelah judul
          // Gunakan Wrap untuk menampilkan item secara fleksibel
          isLoading
              ? Container(
                  child: Wrap(
                      spacing: 10.w, // Jarak horizontal antara item
                      runSpacing: 10.h,
                      children: List.generate(
                          8,
                          (index) => Container(
                                width: (MediaQuery.of(context).size.width -
                                        100.w) /
                                    4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Shimmer efek untuk gambar kategori
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 50.w, // Lebar lingkaran
                                        height: 50.w, // Tinggi lingkaran
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors
                                              .grey, // Warna placeholder saat loading
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    // Jarak antara gambar dan nama kategori
                                    // Shimmer efek untuk nama kategori
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        width: 60.w, // Lebar teks loading
                                        height: 10.h, // Tinggi teks loading
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ))))
              : Wrap(
            spacing: 10.w, // Jarak horizontal antara item
            runSpacing: 10.h, // Jarak vertikal antara item
            children: categories.map((category) {
              return InkWell(
                onTap: () {
                  print("kategori iD" +category.id);
                  Get.toNamed(
                    '/search', // Route ke halaman pencarian
                    arguments: {
                      'categoryId': category.id,
                      'categoryName': category.name,
                    },
                  );
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width - 100.w) /
                      4, // Lebar item menyesuaikan 4 kolom
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Gambar kategori berbentuk lingkaran
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Bentuk lingkaran
                          color: Colorsmaster.primaryColor,
                        ),
                        child: Container(
                          width: 50.w, // Lebar lingkaran
                          height: 50.w, // Tinggi lingkaran
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Bentuk lingkaran
                            color: Colorsmaster.primaryColor,
                            image: DecorationImage(
                              image: NetworkImage(
                                  "$baseURL/assets/images/categories/" +
                                      category.image!), // Gambar kategori
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        category.name,
                        style: TextStyle(fontSize: 8.sp),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ), // Penutup Wrap
        ], // Penutup Column Children
      ), // Penutup Padding Column
    ); // Penutup Padding
  }
}
