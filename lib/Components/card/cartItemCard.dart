import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/ConfirmationBottomSheet%20.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/helper/dBhelper.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/controller/cartController.dart';
import 'package:suryalita_sales_app/controller/homeController.dart';
import 'package:suryalita_sales_app/model/Cart.dart';
import '../helper/helper.dart';

class CartItemCard extends StatelessWidget {
  final Cart? cart;
  Timer? _debounce;
  final CartController controller = Get.find();
  final HomeController homeController = Get.find();

  CartItemCard({this.cart});

  @override
  Widget build(BuildContext context) {
    if (cart == null) {
      return ListTile(
        title: Text('Cart masih kosong'),
      );
    }

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
                child: Image.network(
                  cart!.image != null ? "$baseURL/" + cart!.image! : '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/noimage.jpeg',
                      // Replace with your asset path
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(width: 10.w),

              // Nama produk dan harga
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cart!.itemName!,
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formatRupiahNumber(cart!.price),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cart!.unit,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 10.sp),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Tombol kurang
                                GestureDetector(
                                  onTap: () {
                                    if (cart!.qty.value > 1) {
                                      cart!.qty.value--;
                                      if (_debounce?.isActive ?? false)
                                        _debounce?.cancel();
                                      _debounce = Timer(
                                          const Duration(milliseconds: 500),
                                          () {
                                        controller.updateCartQuantity(cart!.id,
                                            cart!.qty.value, cart!.price);
                                      });
                                    } else {
                                      ConfirmationBottomSheet.show(
                                          title:
                                              "Item akan dihapus dari keranjang",
                                          subtitle: "apakah kamu yakin ?",
                                          onNo: () {
                                            Get.back();
                                          },
                                          onYes: () async {
                                            await DBHelper()
                                                .deleteCartItem(cart!.id);
                                            controller.fetchCartItems();
                                            homeController.updateCartItemCount();
                                            print("ID " + cart!.id.toString());
                                            Get.back();
                                          });
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
                                              cart!.qty.value == 1
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
                                    '${cart!.qty.value}',
                                    // Gunakan quantity.value
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
                                    cart!.qty.value++;
                                    if (_debounce?.isActive ?? false)
                                      _debounce?.cancel();
                                    _debounce = Timer(
                                        const Duration(milliseconds: 500), () {
                                      controller.updateCartQuantity(cart!.id,
                                          cart!.qty.value, cart!.price);
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
                final subtotal = cart!.qty.value * cart!.price;
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
}
