import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/controller/baseController.dart';
import 'package:suryalita_sales_app/view/WeeklySchedulePage.dart';
import 'package:suryalita_sales_app/view/homeView.dart';
import 'package:suryalita_sales_app/view/profileView.dart';
import 'package:suryalita_sales_app/view/transactionListPage.dart';

class Base extends StatelessWidget {
  final BaseController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: controller.selectedIndex.value,
          children: [Homeview(), WeeklySchedulePage(), TransactionListPage(), ProfileView()],
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          backgroundColor: Colors.white,
          onTap: (index) {
            controller.selectedIndex.value = index;
          },
          type: BottomNavigationBarType.fixed, // Menampilkan semua ikon
          selectedItemColor: Colorsmaster.primaryColor, // Warna ikon saat aktif
          unselectedItemColor: Colors.grey, // Warna ikon saat tidak aktif
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 20), // Ikon lebih kecil
              activeIcon: Icon(Icons.home, size: 25, color: Colorsmaster.primaryColor),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined, size: 20),
              activeIcon: Icon(Icons.calendar_today_outlined, size: 25, color: Colorsmaster.primaryColor),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history, size: 20),
              activeIcon: Icon(Icons.history, size: 25, color: Colorsmaster.primaryColor),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, size: 20),
              activeIcon: Icon(Icons.account_circle, size: 25, color: Colorsmaster.primaryColor),
              label: 'Account',
            ),
          ],
        );
      }),

    );
  }
}
