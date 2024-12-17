import 'package:get/get.dart';
import 'package:suryalita_sales_app/controller/baseController.dart';
import 'package:suryalita_sales_app/controller/cartController.dart';
import 'package:suryalita_sales_app/controller/categoryController.dart';
import 'package:suryalita_sales_app/controller/customerController.dart';
import 'package:suryalita_sales_app/controller/homeController.dart';
import 'package:suryalita_sales_app/controller/transactionController.dart';


class Basebinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<BaseController>(() => BaseController());
    Get.put(CartController());
    Get.put(CustomerController());
    Get.put(TransactionController());
  }
}
