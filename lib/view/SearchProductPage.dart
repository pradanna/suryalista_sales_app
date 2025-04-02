import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suryalita_sales_app/Components/modal/categoryModal.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/card/productCard.dart';
import 'package:suryalita_sales_app/Components/modal/sortbyModal.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/controller/categoryController.dart';
import 'package:suryalita_sales_app/controller/searchProductController.dart';

class SearchProductPage extends StatelessWidget {
  final SearchProductController controller = Get.find();
  final CategoryController categoryController = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final categoryId = args['categoryId'];
    final categoryName = args['categoryName'];

    if (args['categoryId'] != null) {
      controller.categoryId.value = categoryId;
      controller.categoryName.value = categoryName;
    }

    controller.fetchItems(reset: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colorsmaster.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Pencarian Produk'),
        centerTitle: true,
      ), // Penutup AppBar

      body: Container(
        color: Colors.white,  // Set background color to white
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            // Field pencarian dengan ikon
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari Produk...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              ),
              onSubmitted: (query) => controller.search.value = query,
            ),

            SizedBox(height: 10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10.w,
                  children: [
                    // Pill kategori
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return CategorySortModal(
                              listCategory: categoryController.categories.value,
                              selectedCategory: controller.categoryId,
                              controller: controller,
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: Colorsmaster.primaryColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Obx(
                              () => Text(
                            controller.categoryId.value.isEmpty
                                ? 'Semua Kategori'
                                : controller.categoryName.value.toString(),
                            style:
                            TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    // Pill urutkan
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SortByModal(controller: controller);
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: Colorsmaster.primaryColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Obx(
                              () => Text(
                            controller.sortBy.value.isEmpty
                                ? 'Urutan: Nama A-Z'
                                : 'Urutan: ' + controller.sortByText.value,
                            style:
                            TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Hasil pencarian produk dalam bentuk card
            Expanded(
              child: Obx(() {
                controller.categoryId.listen((_) {
                  controller.fetchItems(
                      reset: true); // Reset data saat kategori diubah
                });

                controller.search.listen((_) {
                  controller.fetchItems(
                      reset: true); // Reset data saat kategori diubah
                });

                controller.sortByvalue.listen((_) {
                  controller.fetchItems(
                      reset: true); // Reset data saat kategori diubah
                });

                return controller.isLoading.value
                    ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        Container(
                          height: 200.sp,
                          width: 200.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), // Menambahkan border dengan sedikit melengkung
                            image: DecorationImage(
                              image: AssetImage('assets/images/waiting.jpeg'), // Gambar yang ditampilkan
                              fit: BoxFit.cover, // Menyesuaikan gambar agar mengisi seluruh area
                            ),
                          ),
                        ),
                        // CircularProgressIndicator(color: Colorsmaster.primaryColor,),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text("Tunggu sebentar ya..."),
                      ],
                    ))
                    : controller.isEmpty.value
                    ? Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        Container(
                          height: 200.sp,
                          width: 200.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), // Menambahkan border dengan sedikit melengkung
                            image: DecorationImage(
                              image: AssetImage('assets/images/noresult.jpeg'), // Gambar yang ditampilkan
                              fit: BoxFit.cover, // Menyesuaikan gambar agar mengisi seluruh area
                            ),
                          ),
                        ),
                        // CircularProgressIndicator(color: Colorsmaster.primaryColor,),
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(margin: EdgeInsets.symmetric(horizontal: 40.sp),child: Text("Barang yang kamu cari tidak ada, pilih di kategori lain atau gunakan kata pencarian lain...", textAlign: TextAlign.center,)),
                      ],
                    ))
                    : ListView.builder(
                  controller: _scrollController
                    ..addListener(() {
                      // Deteksi apakah scroll sudah di bagian bawah

                      if (controller.isLoading.value == false &&
                          _scrollController.position.pixels ==
                              _scrollController.position.maxScrollExtent) {
                        controller.fetchItems(); // Memanggil fungsi untuk memuat lebih banyak item
                      }
                    }),
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    if (controller.isLoadingLoadMore.value) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final item = controller.items[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: ProductCard(
                        imageWidget: Image.network(
                          "$baseURL/" +
                              item.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/noimage.jpeg',
                              // Replace with your asset path
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        name: item.name,
                        id: item.id,
                        description: item.description!,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ), // Penutup Padding
    );
  }
}
