import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/controller/transactionController.dart';

class TransactionListPage extends StatelessWidget {
  final TransactionController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    _controller.fetchTransactions(reset: true, search: '');
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Transaksi'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (_controller.isEmpty.value) {
          return Center(child: Text('Tidak ada transaksi ditemukan.'));
        }

        return ListView.builder(
          itemCount: _controller.transactions.length,
          itemBuilder: (context, index) {
            final transaction = _controller.transactions[index];
            return InkWell(
              onTap: () {
                Get.toNamed("/detailTransaction",
                    arguments: {'transactionId': transaction.id});
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reference Number
                        Text(
                          '${transaction.referenceNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Divider(
                          color: Colors.grey.withOpacity(0.3),
                          thickness: 1,
                          height: 16,
                        ),
                        SizedBox(height: 8),
                        // Customer Name
                        Text(
                          '${transaction.customerName}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        // Date
                        Text(
                          '${transaction.date}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                          ),
                        ),
                        Divider(
                          color: Colors.grey.withOpacity(0.3),
                          thickness: 1,
                          height: 16,
                        ),
                        // Total Pembelian
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Pembelian',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              formatRupiahInt(transaction.total),
                              // Format total dengan 2 desimal
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
