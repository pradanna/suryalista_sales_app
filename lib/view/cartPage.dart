import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/ConfirmationBottomSheet%20.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/CustomErrorBottomSheet.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/CustomSuccessBottomSheet.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/LoadingBottomSheet.dart';
import 'package:suryalita_sales_app/Components/card/cartItemCard.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/Components/snackbar/showSnackbar.dart';
import 'package:suryalita_sales_app/controller/cartController.dart';
import 'package:suryalita_sales_app/controller/customerController.dart';
import 'package:suryalita_sales_app/controller/homeController.dart';
import 'package:suryalita_sales_app/view/searchCustomerPage.dart';

class CartPage extends StatelessWidget {
  final CartController controller = Get.find();
  final CustomerController cusController = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.fetchCartItems();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Keranjang',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bagian yang dapat di-scroll untuk menampilkan item keranjang
          Expanded(
            child: Container(
              color: Colorsmaster.backgroundColor,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Menampilkan item keranjang
                    Obx(
                          () =>
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.cartItems.length,
                            itemBuilder: (context, index) {
                              final cart = controller.cartItems[index];
                              print(
                                  'Cart Data at index $index: ${cart
                                      .toJson()}'); // Debug data
                              return CartItemCard(cart: cart);

                              // print('cart item length '+ controller.cartItems.length.toString());
                              // return CartItemCard(cart: controller.cartItems[index]);
                            },
                          ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Ubah toko
          Obx(
                () =>
                Container(
                  padding: EdgeInsets.all(16.w),
                  color: Colors.white,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Get.toNamed("searchcustomers");
                        },
                        style: ElevatedButton.styleFrom(
                          padding:
                          EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.w),
                          backgroundColor: Colorsmaster.secondaryColor,
                          // Ganti dengan warna yang diinginkan
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        child: Text(
                          cusController.selectedCustomer.value == null
                              ? "Pilih Toko"
                              : 'Ubah Toko',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colorsmaster.darkColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cusController.selectedCustomer.value == null
                                ? "Toko belum dipilih"
                                : cusController.selectedCustomer.value!.name ??
                                "Toko belum dipilih",
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            cusController.selectedCustomer.value == null
                                ? ""
                                : cusController.selectedCustomer.value!
                                .address ??
                                "",
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ),

          Container(
            color: Colors.white,
            child: Divider(),
          ),

          // Total belanja dan tombol simpan
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() =>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Belanja: ',
                          style: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${formatRupiahNumber(controller.totalPrice)}',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                SizedBox(width: 10.h),
                SizedBox(
                  child: Obx(
                        () =>
                    controller.loadingUploadCart.value
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : cusController.selectedCustomer.value == null
                        ? ElevatedButton(
                      onPressed: () {
                        showSnackbarError("Toko belum dipilih",
                            "Silahkan pilih toko dulu sebelum checkout keranjang",
                            isError: true);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 10.h),
                        backgroundColor: Colors.grey,
                        // Ganti dengan warna yang diinginkan
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                            fontSize: 16.sp, color: Colors.white),
                      ),
                    )
                        : ElevatedButton(
                      onPressed: () async {
                        final customerId =
                            cusController.selectedCustomer.value!.id;
                        final cusName = cusController
                            .selectedCustomer.value!.name;
                        final totalAmount = controller.totalPrice;

                        ConfirmationBottomSheet.show(
                            title: "Konfirmasi penjualan",
                            subtitle: "Tolong di check kembali, apakah data sudah benar",
                            onNo: () {
                              Get.back();
                            },
                            onYes
                            : () async {
                              // Menutup dialog
                              Get.back();

                              // Menampilkan loading
                              showLoadingbottomsheet(
                                  context: context,
                                  successType:
                                  "upload_success");

                              await Future.delayed(
                                  Duration(seconds: 1));

                              print("LOADING");
                              // Memproses upload ke server
                              bool success = await controller
                                  .uploadCartToServer(
                                  customerId);

                              // Menyembunyikan loading
                              Get.back();

                              if (success) {
                                // Reset data customer
                                cusController.selectedCustomer
                                    .value = null;

                                // Menampilkan success bottom sheet
                                showCustomSuccessBottomSheet(
                                  context: context,
                                  successType:
                                  'upload_success',
                                );

                                // Menunggu 3 detik sebelum kembali ke halaman utama
                                await Future.delayed(
                                    Duration(seconds: 2));

                                Get.back();
                                await Future.delayed(
                                    Duration(seconds: 1));
                                Get.back();
                              } else {
                                // Menampilkan snackbar error
                                showSnackbarError(
                                  "Gagal Mengirim data ke server",
                                  "Silahkan hubungi admin",
                                  isError: true,
                                );
                              }
                            });
                        // Get.dialog(
                        //   AlertDialog(
                        //     title: Text(
                        //       'Konfirmasi penjualan',
                        //       style: TextStyle(
                        //           fontSize: 14.sp,
                        //           color: Colors.grey),
                        //     ),
                        //     content: Column(
                        //       crossAxisAlignment:
                        //       CrossAxisAlignment.start,
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Divider(color: Colors.grey[200]),
                        //         SizedBox(height: 8),
                        //         Text(
                        //           '$cusName',
                        //           style: TextStyle(
                        //               fontSize: 16.sp,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //         Text(
                        //           'Total: ${formatRupiahNumber(totalAmount)}',
                        //           style: TextStyle(
                        //               fontSize: 14.sp,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //         SizedBox(height: 20.h),
                        //         Container(
                        //           padding: EdgeInsets.all(10.sp),
                        //           decoration: BoxDecoration(
                        //             color: Colors.green[100],
                        //             borderRadius:
                        //             BorderRadius.circular(8),
                        //           ),
                        //           child: Text(
                        //             "Dengan menekan tombol Ya maka data ini dikirim ke server dan Anda tidak bisa merubahnya lagi.",
                        //             style: TextStyle(
                        //               fontSize: 12.sp,
                        //               color: Colors.green[800],
                        //             ),
                        //             textAlign: TextAlign.center,
                        //           ),
                        //         ),
                        //         Divider(color: Colors.grey[200]),
                        //       ],
                        //     ),
                        //     actions: [
                        //       Row(
                        //         mainAxisAlignment:
                        //         MainAxisAlignment.end,
                        //         children: [
                        //           TextButton(
                        //             onPressed: () {
                        //               Get
                        //                   .back(); // Menutup dialog jika "Tidak" ditekan
                        //             },
                        //             child: Text(
                        //               'Tidak',
                        //               style: TextStyle(
                        //                   color: Colors.red),
                        //             ),
                        //           ),
                        //           TextButton(
                        //             onPressed: () async {
                        //               // Menutup dialog
                        //               Get.back();
                        //
                        //               // Menampilkan loading
                        //               showLoadingbottomsheet(
                        //                   context: context,
                        //                   successType:
                        //                   "upload_success");
                        //
                        //               await Future.delayed(
                        //                   Duration(seconds: 1));
                        //
                        //               print("LOADING");
                        //               // Memproses upload ke server
                        //               bool success = await controller
                        //                   .uploadCartToServer(
                        //                   customerId);
                        //
                        //               // Menyembunyikan loading
                        //               Get.back();
                        //
                        //               if (success) {
                        //                 // Reset data customer
                        //                 cusController.selectedCustomer
                        //                     .value = null;
                        //
                        //                 // Menampilkan success bottom sheet
                        //                 showCustomSuccessBottomSheet(
                        //                   context: context,
                        //                   successType:
                        //                   'upload_success',
                        //                 );
                        //
                        //                 // Menunggu 3 detik sebelum kembali ke halaman utama
                        //                 await Future.delayed(
                        //                     Duration(seconds: 2));
                        //
                        //                 Get.back();
                        //                 await Future.delayed(
                        //                     Duration(seconds: 1));
                        //                 Get.back();
                        //               } else {
                        //                 // Menampilkan snackbar error
                        //                 showSnackbarError(
                        //                   "Gagal Mengirim data ke server",
                        //                   "Silahkan hubungi admin",
                        //                   isError: true,
                        //                 );
                        //               }
                        //             },
                        //             style: TextButton.styleFrom(
                        //               backgroundColor:
                        //               Colorsmaster.primaryColor,
                        //               foregroundColor: Colors.white,
                        //             ),
                        //             child: Text('Ya'),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 10.h),
                        backgroundColor: Colorsmaster.primaryColor,
                        // Ganti dengan warna yang diinginkan
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                            fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
