import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';

class ProductCard extends StatelessWidget {
  final Widget imageWidget;
  final String name;
  final String id;
  final String description; // Added description field

  ProductCard({required this.id, required this.imageWidget, required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed('detailproduct', arguments: {'id': id});
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5.w),
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar produk di sebelah kiri
                Container(
                  width: 60.w,
                  height: 60.w,
                  child: imageWidget,
                ),
                SizedBox(width: 10.w),
                // Konten di sebelah kanan (Nama, Qty, Harga)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Nama produk
                      Container(
                        width: double.infinity,
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Deskripsi produk
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600], // Grey color for description
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: 2, // Limit to 2 lines
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[200]), // Menambahkan Divider di bawah
        ],
      ),
    );
  }
}
