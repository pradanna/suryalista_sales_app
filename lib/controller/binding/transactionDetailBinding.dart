import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/controller/searchProductController.dart';
import 'package:suryalita_sales_app/controller/transactionDetailController.dart';


class TransactionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionDetailController>(() => TransactionDetailController());
  }
}
