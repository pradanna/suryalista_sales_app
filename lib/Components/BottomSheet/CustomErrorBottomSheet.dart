import 'package:flutter/material.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomErrorBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback? onRetry;  // Mengubah menjadi nullable

  const CustomErrorBottomSheet({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.onRetry,  // Parameter onRetry sekarang bisa null
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Image
          SizedBox(
            height: 200, // Height of the image container
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 10),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          SizedBox(height: 20),

          // Show retry button only if onRetry is not null
          if (onRetry != null)
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close Bottom Sheet
                  onRetry!(); // Execute retry action
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Maximum curvature
                  ),
                  backgroundColor: Colorsmaster.primaryColor,
                ),
                child: Text(
                  "Coba Lagi",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White bold font
                  ),
                ),
              ),
            ),
          if (onRetry == null) SizedBox(height: 10), // Add spacing when there's no retry button
        ],
      ),
    );
  }
}

void showCustomErrorBottomSheet({
  required BuildContext context,
  required String errorType,
  VoidCallback? onRetry,  // Sekarang onRetry bisa null
}) {
  String title = '';
  String description = '';
  String imagePath = 'assets/images/default_error.png';

  switch (errorType) {
    case 'no_internet':
      title = 'Tidak Ada Koneksi Internet';
      description =
      'Pastikan perangkat Anda terhubung ke internet dan coba lagi.';
      imagePath = 'assets/images/no_internet.jpeg';
      break;
    case 'timeout':
      title = 'Waktu Habis';
      description =
      'Server tidak merespons dalam waktu yang ditentukan. Silakan coba lagi.';
      imagePath = 'assets/images/rto.jpeg';
      break;
    case 'server_error':
      title = 'Kesalahan Server';
      description = 'Terjadi kesalahan pada server. Silakan coba lagi nanti.';
      imagePath = 'assets/images/server_error.jpeg';
      break;
    case 'wrongusernameorpassword':
      title = 'User atau Password tidak ditemukan';
      description = 'Coba periksa kembali username dan password anda, jika tidak bisa untuk login silahkan kontak admin.';
      imagePath = 'assets/images/password_error.jpeg';
      break;
    case 'belumadafoto':
      title = 'Foto belum ada';
      description = 'tolong ambil foto toko sebelum melakukan absensi.';
      imagePath = 'assets/images/no_photo.jpeg';
      break;
    case 'notindate':
      title = 'Jadwal ini belum bisa dibuka';
      description = 'absensi hanya bisa dilakukan sesuai jadwal.';
      imagePath = 'assets/images/notindate.jpeg';
      break;
    case 'harga_kosong':
      title = 'Harga masih kosong';
      description = 'Silahkan pilih harga sebelum memasukan item kedalam keranjang .';
      imagePath = 'assets/images/server_error.jpeg';
      break;
    default:
      title = 'Terjadi Kesalahan';
      description = 'Kesalahan tidak diketahui. Silakan coba lagi.';
      imagePath = 'assets/images/server_error.jpeg';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return CustomErrorBottomSheet(
        title: title,
        description: description,
        imagePath: imagePath,
        onRetry: onRetry, // Pass onRetry as null or a function
      );
    },
  );
}

