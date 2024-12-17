import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suryalita_sales_app/controller/profileController.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  GetStorage box = GetStorage();


  @override
  Widget build(BuildContext context) {

    // controller.getProfile();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => controller.isLoading.value ? Center(child: CircularProgressIndicator(),) :  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Obx(() => Text(
                controller.email.value,
                style: TextStyle(fontSize: 16),
              )),
              SizedBox(height: 20),
              Text(
                'Username:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Obx(() => Text(
                controller.username.value,
                style: TextStyle(fontSize: 16),
              )),

              SizedBox(height: 20),
              Text(
                'Nama Lengkap:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Obx(() => Text(
                controller.fullName.value,
                style: TextStyle(fontSize: 16),
              )),

              SizedBox(height: 20),
              Text(
                'No HP:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Obx(() => Text(
                controller.phoneNumber.value,
                style: TextStyle(fontSize: 16),
              )),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Tambahkan logika logout di sini
                    await box.remove('token');
                    Get.offAndToNamed('login');
                  },
                  child: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                    backgroundColor: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
