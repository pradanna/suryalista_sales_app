import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/helper/dBhelper.dart';
import 'package:suryalita_sales_app/controller/cartController.dart';
import 'package:suryalita_sales_app/model/Cart.dart';
import '../helper/helper.dart';

class CartItemCard extends StatelessWidget {
  final Cart item;
  Timer? _debounce;
  final CartController controller = Get.find();

  CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gambar produk
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  image: DecorationImage(
                    image: NetworkImage(item.id), // URL gambar produk
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Nama produk dan harga
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.item!.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatRupiahNumber(item.price),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colorsmaster.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            // Tombol kurang
                            GestureDetector(
                              onTap: () {
                                if (item.qty.value > 1) {
                                  item.qty.value--;
                                  if (_debounce?.isActive ?? false)
                                    _debounce?.cancel();
                                  _debounce = Timer(
                                      const Duration(milliseconds: 500), () {
                                    DBHelper().updateCartQuantity(
                                        parseToInt(item.id),
                                        item.qty.value,
                                        item.price);
                                  });
                                } else {
                                  _showDeleteDialog(context);
                                }
                              }, // Logika pengurangan kuantitas
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colorsmaster.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Obx(() {
                                      return Icon(
                                          item.qty.value == 1
                                              ? Icons.delete_outlined
                                              : Icons.remove,
                                          color: Colors.black,
                                          size: 16.sp);
                                    })),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            // Tampilkan kuantitas
                            Obx(() {
                              return Text(
                                '${item.qty.value}', // Gunakan quantity.value
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }),
                            SizedBox(width: 10.w),
                            // Tombol tambah
                            GestureDetector(
                              onTap: () {
                                item.qty.value++;
                                if (_debounce?.isActive ?? false)
                                  _debounce?.cancel();
                                _debounce = Timer(
                                    const Duration(milliseconds: 500), () {
                                  DBHelper().updateCartQuantity(
                                      parseToInt(item.id),
                                      item.qty.value,
                                      item.price);
                                });
                              }, // Logika penambahan kuantitas
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colorsmaster.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Icon(Icons.add,
                                      color: Colors.black, size: 16.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Garis pemisah
          Divider(),

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Obx(() {
                // Calculate subtotal
                final subtotal = item.qty.value * item.price;
                return Text(
                  formatRupiahNumber(subtotal),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colorsmaster.primaryColor,
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi penghapusan
  void _showDeleteDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Konfirmasi Hapus",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Apakah Anda yakin ingin menghapus item ini dari keranjang?",
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 10),
          Divider(), // Garis tipis setelah konfirmasi
          SizedBox(height: 10),
          // Tombol di sebelah kanan
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: Get.back, child: Text("Tidak")),
              ElevatedButton(
                onPressed: () async {
                  // Hapus item dari database jika ya
                  await DBHelper().deleteCartItem(parseToInt(item.id));
                  controller.fetchCartItems();
                  Get.back(); // Menutup dialog
                  Get.snackbar('Berhasil', 'Item telah dihapus dari keranjang');

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Tombol warna merah
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text('Hapus', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      radius: 10.0,
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      contentPadding: EdgeInsets.all(15),
    );
  }
}
