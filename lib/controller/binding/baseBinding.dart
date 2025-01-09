import 'package:get/get.dart';
import 'package:suryalita_sales_app/controller/AttendanceController.dart';
import 'package:suryalita_sales_app/controller/baseController.dart';
import 'package:suryalita_sales_app/controller/cartController.dart';
import 'package:suryalita_sales_app/controller/categoryController.dart';
import 'package:suryalita_sales_app/controller/customerController.dart';
import 'package:suryalita_sales_app/controller/homeController.dart';
import 'package:suryalita_sales_app/controller/profileController.dart';
import 'package:suryalita_sales_app/controller/transactionController.dart';
import 'package:suryalita_sales_app/view/WeeklySchedulePage.dart';


class Basebinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<BaseController>(() => BaseController());
    Get.lazyPut<AttendanceController>(() => AttendanceController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.put(CartController());
    Get.put(CustomerController());
    Get.put(TransactionController());
  }
}
