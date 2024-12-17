import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:suryalita_sales_app/Components/textField/textFieldleftIcon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:suryalita_sales_app/controller/loginController.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find();
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            height: MediaQuery.of(context).size.height * 0.52,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo
          Positioned(
            top: 50,
            left: 30,
            child: Image.asset(
              'assets/images/logo.png',
              height: 50, // Adjust the height of the logo as needed
            ),
          ),
          // Bottom sheet for login form
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Masukan Email dan Password',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 20),
                        buildTextFieldWithIcon(
                          Icons.account_circle_rounded,
                          'Username',
                          onChanged: (value) => controller.username.value = value,
                          borderColor: Colors.black, // Change border color here
                        ),
                        SizedBox(height: 20),
                        buildTextFieldWithIcon(
                          Icons.lock,
                          'Password',
                          onChanged: (value) => controller.password.value = value,
                          obscureText: true,
                          borderColor: Colors.black, // Change border color here
                        ),
                        SizedBox(height: 50),
                        Obx(() => controller.isLoading.value
                            ? CircularProgressIndicator()
                            : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.login,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              foregroundColor: Colors.white,
                              backgroundColor: Colorsmaster.primaryColor,
                            ),
                            child: Text('Login'),
                          ),
                        )),
                        // InkWell(onTap: (){
                        //   Get.toNamed("/register");
                        // },child: Text("Belum punya akun? Daftar Sekarang", style: TextStyle(color: Colorsmaster.primaryColor),),)
                    SizedBox(height: 16.h),
                    RichText(
                      text: TextSpan(
                        text: 'Jika ada masalah, silakan hubungi ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'admin',
                            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = controller.contactAdmin,
                          ),
                        ],
                      ),)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }


}
