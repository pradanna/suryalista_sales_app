import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/apiRequest/apiServices.dart';
import 'package:suryalita_sales_app/controller/profileController.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.find();

  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colorsmaster.backgroundColor,
        elevation: 0,
        title: Text('Profil'),
        centerTitle: true,
      ),
      body: Container(
        color:  Colorsmaster.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),

                    // Photo Profile
                    CircleAvatar(
                      radius: 75, // Diameter 150.w
                      backgroundImage:
                          controller.photoUrl.value?.isNotEmpty ?? false
                              ? NetworkImage(baseURL +
                                  "/assets/images/photosales/" +
                                  controller.photoUrl.value!)
                              : AssetImage('assets/images/default_avatar.jpeg')
                                  as ImageProvider,
                    ),

                    SizedBox(height: 50),

                    // Nama
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.grey),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              controller.name.value,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey[200],
                    ),
                    SizedBox(height: 15),

                    // Address
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alamat',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              controller.address.value ?? "-",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey[200],
                    ),
                    SizedBox(height: 15),

                    // Phone
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.grey),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No HP',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              controller.phoneNumber?.value ?? "-",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey[200],
                    ),
                    SizedBox(height: 15),

                    // Username
                    Row(
                      children: [
                        Icon(Icons.account_circle, color: Colors.grey),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              controller.username.value,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey[200],
                    ),
                    Spacer(),

                    // Logout Button
                    ElevatedButton(
                      onPressed: () async {
                        await box.remove('token_litasurya');
                        Get.offAndToNamed('login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red.shade400, // Background merah muda
                        foregroundColor: Colors.white, // Teks putih
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
        ),
      ),
    );
  }
}
