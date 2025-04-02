import 'package:flutter/material.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';

class CustomSuccessBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String? image;

  const CustomSuccessBottomSheet({
    Key? key,
    required this.title,
    required this.description,
    this.image,
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
                image ?? "assets/images/success.jpeg",
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
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
        ],
      ),
    );
  }
}

void showCustomSuccessBottomSheet({
  required BuildContext context,
  required String successType,
  String? image,
  int? delay, // Waktu delay dalam milidetik
  VoidCallback? onDismissed, // Callback ketika bottom sheet tertutup
}) {
  String title = '';
  String description = '';

  switch (successType) {
    case 'upload_success':
      title = 'Data Berhasil Dikirim';
      image = 'assets/images/success.jpeg';
      description = 'Data Anda berhasil dikirim ke server.';
      break;
    case 'success_updatestat':
      title = 'Yeeey, Transaksi sudah Selesai';
      image = 'success.jpeg';
      description = 'Transaksi berhasil diselesaikan.';
      break;
    case 'loading':
      title = 'Mohon Tunggu';
      image = 'assets/images/waiting.jpeg';
      description = 'Sedang mengirim data ke Server.';
      break;
    default:
      title = 'Operasi Sukses';
      image = 'assets/images/success.jpeg';
      description = 'Operasi berhasil dilakukan.';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return CustomSuccessBottomSheet(
        title: title,
        description: description,
        image: image,
      );
    },
  ).whenComplete(() {
    // Callback saat bottom sheet ditutup manual
    if (onDismissed != null) {
      onDismissed();
    }
  });

  if (delay != null) {
    // Menutup bottom sheet setelah delay selesai
    Future.delayed(Duration(milliseconds: delay), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Menutup bottom sheet
        if (onDismissed != null) {
          onDismissed(); // Callback saat delay selesai dan sheet tertutup
        }
      }
    });
  }
}
