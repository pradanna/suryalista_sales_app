import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/BottomSheet/CustomErrorBottomSheet.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/helper/helper.dart';
import 'package:suryalita_sales_app/Components/state/loadingWithImage.dart';
import 'package:suryalita_sales_app/Components/snackbar/showSnackbar.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
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
        body: Container(
          color: Colors.white, // Set the background color to white
          child: Obx(() {
            if (controller.isLoading.value) {
              return Loadingwithimage();
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
                            width: double.infinity,
                            height: 200.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Image.network(
                              "$baseURL/" + item!.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/noimage.jpeg',
                                  // Fallback image
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Nama produk
                        Text(
                          item.name,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        SizedBox(height: 16.h),

                        Container(
                            child: item == null ||
                                    item.prices == null ||
                                    item.prices!.isEmpty
                                ? Text(
                                    "Belum ada Harga",
                                  )
                                : Column(
                                    children: List.generate(item.prices!.length,
                                        (index) {
                                      // Sort the prices based on the custom unit order
                                      List<String> unitOrder = [
                                        'pcs',
                                        'lusin',
                                        'karton',
                                        'trader'
                                      ];

                                      // Sorting the prices list based on the custom order
                                      item.prices!.sort((a, b) {
                                        return unitOrder
                                            .indexOf(a.unit)
                                            .compareTo(
                                                unitOrder.indexOf(b.unit));
                                      });

                                      final price = item.prices![index];
                                      return priceOption(
                                          formatRupiahInt(price.price),
                                          price.unit,
                                          price.price,
                                          price.description);
                                    }),
                                  )),

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
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),

                // Bagian total harga dan kontrol kuantitas tetap di bawah
                Divider(
                  color: Colors.grey[100],
                  height: 1,
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
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
                                item == null ||
                                        item.prices == null ||
                                        item.prices!.isEmpty
                                    ? "Rp 0"
                                    : formatRupiahNumber(
                                        controller.totalPrice.value),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Kontrol kuantitas
                          item == null ||
                                  item.prices == null ||
                                  item.prices!.isEmpty
                              ? Container()
                              : Row(
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
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    // Jarak antara tombol

                                    GestureDetector(
                                      onTap: () {
                                        _showQuantityDialog(
                                            context); // Show the quantity dialog
                                      },
                                      child: Text(
                                        '${controller.quantity.value.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
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
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    // Satuan terpilih
                                    Text(
                                      '(${controller.selectedUnit.value})',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                      SizedBox(height: 10.h),

                      // Tombol masukkan ke keranjang
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            item == null ||
                                    item.prices == null ||
                                    item.prices!.isEmpty
                                ? showCustomErrorBottomSheet(
                                    context: context, errorType: 'harga_kosong')
                                : Get.dialog(
                                    AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Barang:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(controller.item.value!.name),
                                          SizedBox(height: 8),
                                          Text(
                                            'Jumlah:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              '${controller.quantity.value} ${controller.selectedUnit.value}'),
                                          SizedBox(height: 8),
                                          Text(
                                            'Total Harga:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                            thickness: 1,
                                            color: Colors.grey.shade300),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Get.back(); // Menutup dialog
                                                },
                                                child: Text(
                                                  'TIDAK',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              ElevatedButton(
                                                onPressed: () {
                                                  cartController.addToCart(
                                                    id,
                                                    controller.quantity.value,
                                                    controller
                                                        .selectedPrice.value,
                                                    controller
                                                        .selectedUnit.value,
                                                    controller.item.value!.name,
                                                    controller
                                                        .item.value!.image,
                                                  );
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 300),
                                                      () {
                                                    if (cartController
                                                            .loadingInputSqlite
                                                            .value ==
                                                        false) {
                                                      if (cartController
                                                          .successInput.value) {
                                                        Get.back(); // Menutup dialog setelah konfirmasi
                                                        Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    300), () {
                                                          Get.back();
                                                          showSnackbarError(
                                                              'Berhasil',
                                                              'Barang berhasil ditambahkan ke keranjang');
                                                        });
                                                      } else {
                                                        showSnackbarError(
                                                            "Gagal Memasukan data ke keranjang",
                                                            "Silahkan hubungi admin");
                                                      }
                                                    } else {
                                                      showSnackbarError(
                                                          "loading ", "True");
                                                    }
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colorsmaster.primaryColor,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Text(
                                                  'YA',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                            backgroundColor: item == null ||
                                    item.prices == null ||
                                    item.prices!.isEmpty
                                ? Colors.grey
                                : Colorsmaster.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.r),
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
          }),
        ));
  }

  Widget priceOption(String price, String unit, int value, String deskripsi) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.setSelectedUnit(unit, value); // Set selected unit on tap
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 3.h),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: controller.selectedUnit.value == unit
                    ? Colorsmaster.lightColor
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: controller.selectedUnit.value == unit
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: controller.selectedUnit.value == unit
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      Text(
                        deskripsi,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: controller.selectedUnit.value == unit
                              ? Colors.white54
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuantityDialog(BuildContext context) {
    // Create a TextEditingController to control the input field
    TextEditingController quantityController = TextEditingController(
      text: controller.quantity.value.toString(), // Set current quantity
    );

    // Open the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Masukkan Jumlah'),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah',
              hintText: 'Masukkan jumlah',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Optionally, validate input as it's typed
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog without saving
                Get.back();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Get the entered quantity
                int newQuantity = int.tryParse(quantityController.text) ?? 1;

                // Validate and update the quantity (set a minimum of 1)
                if (newQuantity < 1) {
                  newQuantity = 1;
                }

                // Update the quantity
                controller.quantity.value = newQuantity;

                // Close the dialog
                Get.back();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
