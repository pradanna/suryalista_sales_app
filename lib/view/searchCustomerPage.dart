import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/CustomErrorBottomSheet.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/state/loadingWithImage.dart';
import 'package:suryalita_sales_app/Components/state/noResultSearch.dart';
import 'package:suryalita_sales_app/controller/customerController.dart';
import 'package:suryalita_sales_app/model/customer.dart';

class SearchCustomerPage extends StatelessWidget {
  final CustomerController customerController = Get.find();

  @override
  Widget build(BuildContext context) {
    customerController.fetchTokoCustomers();

    return Scaffold(
        appBar: AppBar(
          title: Text('Cari Toko'),
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: RefreshIndicator(
          color: Colorsmaster.primaryColor,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Field pencarian dengan background putih dan border abu-abu pudar
                TextField(
                  onChanged: (value) =>
                      customerController.searchCustomer(value),
                  decoration: InputDecoration(
                    hintText: 'Cari customer...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                SizedBox(height: 10),

                // Menampilkan daftar customer
                Expanded(
                  child: Obx(() {
                    print("isLoading: ${customerController.isLoading.value}");
                    return customerController.isLoading.value
                        ? const Loadingwithimage()
                        : customerController.isError.value
                            ? CustomErrorBottomSheet(
                                description: "Silahkan hubungi admin ",
                                title: "Terjadi kesalahan",
                                imagePath: "assets/images/error.jpeg",
                                onRetry: () {
                                  customerController.fetchTokoCustomers();
                                },
                              )
                            : customerController.filteredCustomers.isEmpty
                                ? Noresultsearch(
                                    message:
                                        "Toko yang kamu cari tidak ada, coba dengan kata kunci lain...")
                                : ListView.builder(
                                    itemCount: customerController
                                        .filteredCustomers.length,
                                    itemBuilder: (context, index) {
                                      final customer = customerController
                                          .filteredCustomers[index];
                                      return Column(
                                        children: [
                                          ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 5, horizontal: 0),
                                            title: Text(
                                              customer.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              customer.address,
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 11.sp),
                                            ),
                                            trailing: ElevatedButton(
                                              onPressed: () {
                                                customerController
                                                    .setSelectedCustomer(
                                                        customer);
                                                Get.back();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colorsmaster
                                                      .primaryColor),
                                              child: Text('Pilih',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          Divider(
                                              color: Colors.grey[100],
                                              thickness: 1),
                                          // Divider pudar antar item
                                        ],
                                      );
                                    },
                                  );
                  }),
                ),
              ],
            ),
          ),
          onRefresh: () async {
            customerController.fetchTokoCustomers();
          },
        ));
  }
}
