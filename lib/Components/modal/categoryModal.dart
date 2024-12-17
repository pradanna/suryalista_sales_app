import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/controller/searchProductController.dart';
import 'package:suryalita_sales_app/model/Category.dart';

class CategorySortModal extends StatelessWidget {
  final List<Category> listCategory;
  final RxString selectedCategory;
  final SearchProductController controller;

  CategorySortModal({
    required this.listCategory,
    required this.selectedCategory,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Pilih Kategori',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true, // Agar mengikuti konten
              itemCount: listCategory.length,
              itemBuilder: (context, index) {
                final category = listCategory[index];

                if (index == 0) {
                  return ListTile(
                    title: Text('Semua Kategori'),
                    onTap: () {
                      selectedCategory.value = ''; // Kosongkan ID kategori
                      Navigator.pop(context);
                      controller.categoryId.value = ''; // Reset kategori di controller
                      // Fetch ulang semua item
                    },
                  );
                }

                return ListTile(
                  title: Text(category.name),
                  onTap: () {
                    selectedCategory.value = category.id; // Simpan ID kategori
                    controller.categoryId.value = category.id;
                    controller.categoryName.value = category.name;
                    Navigator.pop(context);


                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
