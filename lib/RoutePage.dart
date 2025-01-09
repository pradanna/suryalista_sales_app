
import 'package:get/get.dart';
import 'package:suryalita_sales_app/controller/binding/baseBinding.dart';
import 'package:suryalita_sales_app/controller/binding/customerBinding.dart';
import 'package:suryalita_sales_app/controller/binding/detailProductBinding.dart';
import 'package:suryalita_sales_app/controller/binding/searchBinding.dart';
import 'package:suryalita_sales_app/controller/binding/transactionDetailBinding.dart';
import 'package:suryalita_sales_app/view/AbsensiDetailPage.dart';
import 'package:suryalita_sales_app/view/AbsensiPage.dart';
import 'package:suryalita_sales_app/view/AbsensiPageTerlewat.dart';
import 'package:suryalita_sales_app/view/ProductDetailPage.dart';
import 'package:suryalita_sales_app/view/SearchProductPage.dart';
import 'package:suryalita_sales_app/view/WeeklySchedulePage.dart';
import 'package:suryalita_sales_app/view/base.dart';
import 'package:suryalita_sales_app/view/cartPage.dart';
import 'package:suryalita_sales_app/view/customerPage.dart';
import 'package:suryalita_sales_app/view/login.dart';
import 'package:suryalita_sales_app/view/qrScanPage.dart';
import 'package:suryalita_sales_app/view/searchCustomerPage.dart';
import 'package:suryalita_sales_app/view/transactionDetailPage.dart';


import 'controller/binding/loginBinding.dart';
import 'view/splashScreen.dart';

class RoutePage {
  List<GetPage> route = [
    GetPage(name: "/", page: () => SplashScreen()),
    GetPage(name: "/login", page: () => LoginView(), binding: LoginBinding()),
    GetPage(name: "/base", page: () => Base(), binding: Basebinding(),),
    GetPage(name: "/search", page: () => SearchProductPage(), binding: SearchBinding()),
    GetPage(name: "/detailproduct", page: () => ProductDetailPage(), binding: Detailproductbinding()),
    GetPage(name: "/cart", page: () => CartPage()),
    GetPage(name: "/scanqr", page: () => QRScannerPage()),
    GetPage(name: "/absenpage", page: () => AbsensiPage()),
    GetPage(name: "/absenpageterlewat", page: () => AbsensiPageTerlewat()),
    GetPage(name: "/absendetailpage", page: () => AbsensiDetailPage()),
    GetPage(name: "/customers", page: () => CustomerPage(), binding: CustomerBinding()),
    GetPage(name: "/searchcustomers", page: () => SearchCustomerPage(), binding: CustomerBinding()),
    GetPage(name: "/detailTransaction", page: () => TransactionDetailPage(), binding: TransactionDetailBinding()),
    GetPage(name: "/weeklySchedule", page: () => WeeklySchedulePage(),),
  ];
}
