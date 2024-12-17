import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';

class ProductCard extends StatelessWidget {
  final Widget imageWidget;
  final String name;
  final String id;

  ProductCard({required this.id,required this.imageWidget, required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.toNamed('detailproduct', arguments: {'id' : id});
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Color.fromARGB(25, 00, 00, 00), blurRadius: 5, offset: Offset(2, 2))]),
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
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
                  // SizedBox(height: 5.h),
                  // Kuantitas produk
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
