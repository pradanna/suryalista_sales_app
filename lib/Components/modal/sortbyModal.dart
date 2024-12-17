import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suryalita_sales_app/controller/searchProductController.dart';

class SortByModal extends StatelessWidget {
  final SearchProductController controller;

  SortByModal({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Urutkan Berdasarkan'),
          ListTile(
            title: Text('Nama A-Z'),
            onTap: () {
              controller.sortByText.value = 'Nama A-Z';
              controller.sortByvalue.value = 'ascname';
              controller.sortBy.value = 'name';
              controller.sortOrder.value = 'asc';
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Nama Z-A'),
            onTap: () {
              print(" hehe 1");
              controller.sortByText.value = 'Nama Z-A';
              controller.sortByvalue.value = 'descname';
              controller.sortBy.value = 'name';
              controller.sortOrder.value = 'desc';
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
