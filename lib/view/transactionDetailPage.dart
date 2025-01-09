import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/CustomSuccessBottomSheet.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/Components/padding/GenosPadding.dart';
import 'package:suryalita_sales_app/Components/pills/statusPill.dart';
import 'package:suryalita_sales_app/Components/snackbar/showSnackbar.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/controller/transactionController.dart';
import 'package:suryalita_sales_app/controller/transactionDetailController.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransactionDetailController controller = Get.find();
    final TransactionController transactionController = Get.find();

    final args = Get.arguments;
    String transactionId = args['transactionId'];
    print('transaksi ID nya $transactionId');
    controller.fetchTransactionDetail(transactionId);

    return Scaffold(
      appBar: AppBar(title: Text('Detail Transaksi'), backgroundColor: Colors.white,),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final transaction = controller.transaction.value;
        if (transaction == null) {
          return Center(child: Text('Transaksi tidak ditemukan.'));
        }

        // Calculate total transaction value
        double totalTransaction = 0.0;
        transaction.carts?.forEach((cart) {
          totalTransaction += cart.total; // Add total of each cart item
        });

        return Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Padding(
                        padding:  EdgeInsets.all(marginHorizontal),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nomor Referensi : ${transaction.referenceNumber}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${transaction.customerName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                StatusPill(transaction.status)
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tanggal: ${transaction.date}',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey[100],),
                      Genospadding(
                        child: Text('Daftar Barang:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      // Display Cart Items
                      ...transaction.carts?.map((cart) {
                            return Column(
                              children: [
                                Container(
                                  color: cart.status == "kosong" ? Colors.red[100] : Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: marginHorizontal),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Gambar Barang
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          "$baseURL/${cart.item?.image}" ??
                                              '',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/noimage.jpeg',
                                              // Replace with your asset path
                                              fit: BoxFit.cover,
                                              width: 80,
                                              height: 80,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      // Data Barang
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cart.item?.name ?? 'Tidak ada Nama',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Qty: ${cart.qty.value} ${cart.unit}' ,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Harga: ${formatRupiahInt(cart.price)}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Total: ${formatRupiahInt(cart.total)}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 1, color: Colors.grey[200],), // Garis tipis antara setiap item
                              ],
                            );
                          }).toList() ??
                          [],
                    ],
                  ),
                ),
              ),
              // Total Transaction Section (Fixed at bottom)
              Container(
                padding: EdgeInsets.only(
                    left: 16.0.w, right: 16.w, top: 8.h, bottom: 8.h),
                color: Colors.white,
                // Optional: background color for the total section
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Transaksi:',
                          style: TextStyle(fontSize: 12.sp, color: Colors.black),
                        ),
                        Text(
                          formatRupiahInt(transaction.total),
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    controller.loadingUpdateStatus.value ? Center(child: CircularProgressIndicator(color: Colorsmaster.primaryColor,),) :  transaction.status == "Pesanan Diproses"
                        ? ElevatedButton(
                            onPressed: () async  {
                              if (transactionId != null) {
                                bool success = await controller.updateTransactionStatus(transactionId);
                                if (success) {
                                  showCustomSuccessBottomSheet(context: context, successType: 'success_updatestat');
                                  await Future.delayed(
                                      Duration(seconds: 2));
                                  Get.back();
                                  await Future.delayed(
                                      Duration(microseconds: 100));
                                  transactionController.fetchTransactions(reset: true);
                                  Get.back();
                                } else {
                                  showSnackbarError('Gagal', 'Gagal memperbarui status transaksi.');
                                }
                              } else {
                                print('ID transaksi tidak ditemukan.');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colorsmaster.primaryColor,
                              // Ganti dengan warna primary Anda
                              foregroundColor: Colors.white,
                              // Warna teks putih
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    50), // Border radius penuh
                              ),
                            ),
                            child: Text(
                              'Selesai',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // Teks bold
                                fontSize: 16, // Ukuran teks
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              showSnackbarError("Transaksi Belum diproses",
                                  "Maaf transaksi belum diproses, jadi tansaksi tidak bisa diselesaikan, Silahkan hubungi admin kalau semisal transaksi sudah selesai",
                                  isError: true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[400],
                              // Ganti dengan warna primary Anda
                              foregroundColor: Colors.white,
                              // Warna teks putih
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    50), // Border radius penuh
                              ),
                            ),
                            child: Text(
                              'Selesai',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // Teks bold
                                fontSize: 16, // Ukuran teks
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
