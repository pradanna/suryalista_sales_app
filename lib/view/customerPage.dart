import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/controller/customerController.dart';

class CustomerPage extends StatelessWidget {
  final CustomerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Toko"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.customers.isEmpty) {
          return Center(child: Text("Tidak ada data toko"));
        }

        return ListView.builder(
          itemCount: controller.customers.length,
          itemBuilder: (context, index) {
            final customer = controller.customers[index];
            return ListTile(
              title: Text(customer.name),
              subtitle: Text(customer.phone),
              trailing: Text("Poin: ${customer.point}"),
              onTap: () {
                Get.snackbar("Info", "Alamat: ${customer.address}");
              },
            );
          },
        );
      }),
    );
  }
}
