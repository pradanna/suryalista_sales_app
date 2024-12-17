import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/controller/productDetailController.dart';
import 'package:suryalita_sales_app/controller/searchProductController.dart';


class Detailproductbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailController>(() => ProductDetailController());
  }
}
