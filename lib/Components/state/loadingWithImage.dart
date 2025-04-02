import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loadingwithimage extends StatelessWidget {

  // Constructor untuk mengambil gambar dan pesan
  const Loadingwithimage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Memastikan widget di tengah
        children: [
          SizedBox(
            height: 80.h,
          ),
          Container(
            height: 200.sp,
            width: 200.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // Menambahkan border dengan sedikit melengkung
              image: DecorationImage(
                image: AssetImage("assets/images/waiting.jpeg"), // Gambar yang ditampilkan
                fit: BoxFit.cover, // Menyesuaikan gambar agar mengisi seluruh area
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text("Tunggu sebentar ya..."),
        ],
      ),
    );
  }
}
