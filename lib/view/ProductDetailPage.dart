import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/Components/snackbar/showSnackbar.dart';
import 'package:suryalita_sales_app/controller/cartController.dart';
import 'package:suryalita_sales_app/controller/productDetailController.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductDetailController controller = Get.find();
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>;
    final id = arguments['id'];

    controller.fetchItems(id);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Detail Produk',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.isEmpty.value) {
            return Center(child: Text("Item not found"));
          }

          final item = controller.item.value;

          return Column(
            children: [
              // Bagian yang dapat di-scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar produk
                      Center(
                        child: Container(
                          width: 200.w,
                          height: 200.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://assets.unileversolutions.com/v1/87635838.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Nama produk
                      Text(
                        item!.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      item == null || item.prices == null || item.prices!.isEmpty
                          ? Text("No price options available")
                          : ListView.builder(
                              shrinkWrap: true,
                              // Agar tidak mengambil seluruh ruang jika dalam Column
                              itemCount: item.prices!.length,
                              itemBuilder: (context, index) {
                                final price = item.prices![index];
                                return priceOption(
                                  formatRupiahInt(price.price),
                                  price.unit,
                                  price.price,
                                );
                              },
                            ),
                      SizedBox(height: 10.h),

                      Divider(),

                      // Deskripsi produk
                      Text(
                        'Deskripsi Produk',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        item.description!,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),

              // Bagian total harga dan kontrol kuantitas tetap di bawah
              Container(
                padding: EdgeInsets.all(16.w),
                color: Colors.white,
                child: Column(
                  children: [
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Total harga
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  formatRupiahNumber(
                                      controller.totalPrice.value),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            // Kontrol kuantitas
                            Row(
                              children: [
                                // Container untuk tombol kurang
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colorsmaster.secondaryColor,
                                    // Ganti dengan warna sekunder Anda
                                    shape: BoxShape.circle,
                                  ),
                                  child: GestureDetector(
                                    onTap: controller.decreaseQuantity,
                                    child: Padding(
                                      padding: EdgeInsets.all(3.0),
                                      // Anda bisa menyesuaikan padding sesuai kebutuhan
                                      child: Icon(Icons.remove,
                                          color: Colorsmaster.darkColor),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                // Jarak antara tombol

                                Text(
                                  '${controller.quantity.value.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                // Jarak antara jumlah dan tombol

                                // Container untuk tombol tambah
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colorsmaster.secondaryColor,
                                    // Ganti dengan warna sekunder Anda
                                    shape: BoxShape.circle,
                                  ),
                                  child: GestureDetector(
                                    onTap: controller.increaseQuantity,
                                    child: Padding(
                                      padding: EdgeInsets.all(3.0),
                                      // Anda bisa menyesuaikan padding sesuai kebutuhan
                                      child: Icon(Icons.add,
                                          color: Colorsmaster.darkColor),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                // Satuan terpilih
                                Obx(
                                  () => Text(
                                    '(${controller.selectedUnit.value})',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    SizedBox(height: 10.h),

                    // Tombol masukkan ke keranjang
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'KONFIRMASI',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colorsmaster.primaryColor,
                                    ),
                                  ),
                                  Divider(
                                      thickness: 1,
                                      color: Colors.grey.shade300),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Barang:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(controller.item.value!.name),
                                  SizedBox(height: 8),
                                  Text(
                                    'Jumlah:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      '${controller.quantity.value} ${controller.selectedUnit.value}'),
                                  SizedBox(height: 8),
                                  Text(
                                    'Total Harga:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    formatRupiahNumber(
                                        controller.totalPrice.value),
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              actionsPadding: EdgeInsets.only(top: 8),
                              actions: [
                                Divider(
                                    thickness: 1, color: Colors.grey.shade300),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back(); // Menutup dialog
                                        },
                                        child: Text(
                                          'TIDAK',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          cartController.addToCart(
                                              id,
                                              controller.quantity.value,
                                              controller.totalPrice.value,
                                              controller.selectedUnit.value,
                                              controller.item.value!.name,
                                              controller.item.value!.image);
                                          Future.delayed(
                                              Duration(milliseconds: 300), () {
                                            print('A');
                                            if (cartController
                                                    .loadingInputSqlite.value ==
                                                false) {
                                              print('B');
                                              if (cartController
                                                  .successInput.value) {
                                                print('C');
                                                Get.back(); // Menutup dialog setelah konfirmasi

                                                Future.delayed(
                                                    Duration(milliseconds: 300),
                                                    () {
                                                  Get.back();
                                                  showSnackbarError('Berhasil',
                                                      'Barang berhasil ditambahkan ke keranjang');
                                                });
                                              } else {
                                                print('D');
                                                showSnackbarError(
                                                    "Gagal Memasukan data ke keranjang",
                                                    "Silahkan hubungi admin");
                                              }
                                            } else {
                                              print('E');
                                              showSnackbarError(
                                                  "loading ", "True");
                                            }
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colorsmaster.primaryColor,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'YA',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          backgroundColor: Colorsmaster.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Masukkan ke Keranjang',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }));
  }

  Widget priceOption(String price, String unit, int value) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.setSelectedUnit(unit, value);
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: controller.selectedUnit.value == unit
                ? Colorsmaster.primaryColor
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: controller.selectedUnit.value == unit
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: controller.selectedUnit.value == unit
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
