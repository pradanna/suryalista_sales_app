import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/controller/searchProductController.dart';


class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchProductController>(() => SearchProductController());
  }
}
