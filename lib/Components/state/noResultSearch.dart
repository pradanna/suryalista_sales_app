import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Noresultsearch extends StatelessWidget {
  final String message;

  // Constructor untuk mengambil gambar dan pesan
  const Noresultsearch({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // Memastikan widget di tengah
        children: [
          SizedBox(
            height: 50.h,
          ),
          Container(
            height: 200.sp,
            width: 200.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // Menambahkan border dengan sedikit melengkung
              image: DecorationImage(
                image: AssetImage("assets/images/noresult.jpeg"),
                // Gambar yang ditampilkan
                fit: BoxFit
                    .cover, // Menyesuaikan gambar agar mengisi seluruh area
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
              width: 200.sp,
              child: Text(
                message,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }
}
