import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/controller/transactionDetailController.dart';

class TransactionDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransactionDetailController controller = Get.find();

    final args = Get.arguments;
    String transactionId = args['transactionId'];
    print('transaksi ID nya $transactionId');
    controller.fetchTransactionDetail(transactionId);

    return Scaffold(
      appBar: AppBar(title: Text('Detail Transaksi')),
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
          totalTransaction += cart.total;  // Add total of each cart item
        });

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Text(
                      'Referensi: ${transaction.referenceNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${transaction.customerName}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tanggal: ${transaction.date}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Divider(),
                    Text('Daftar Barang:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    // Display Cart Items
                    ...transaction.carts?.map((cart) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gambar Barang
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    cart.item?.image ?? '',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/noimage.jpeg', // Replace with your asset path
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cart.item?.name ?? 'Nama Barang',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Qty: ${cart.qty.value}',
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Harga: ${formatRupiahInt(cart.price)}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.black),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total: ${formatRupiahInt(cart.total)}',
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(), // Garis tipis antara setiap item
                        ],
                      );
                    }).toList() ?? [],
                  ],
                ),
              ),
            ),
            // Total Transaction Section (Fixed at bottom)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                color: Colors.white, // Optional: background color for the total section
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Transaksi:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      formatRupiahInt(transaction.total),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
