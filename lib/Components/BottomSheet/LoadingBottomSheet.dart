import 'package:flutter/material.dart';
import 'package:suryalita_sales_app/Components/color/colorsMaster.dart';

class Loadingbottomsheet extends StatelessWidget {
  final String title;
  final String description;

  const Loadingbottomsheet({
    Key? key,
    required this.title,
    required this.description,
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
                "assets/images/waiting.jpeg",
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

void showLoadingbottomsheet({
  required BuildContext context,
  required String successType,
}) {
  String title = '';
  String description = '';
  String imagePath = 'assets/images/waiting.jpeg';

  switch (successType) {
    case 'upload_success':

      title = 'Mohon Tunggu';
      description = 'Sedang mengirim data ke server.';
      break;
    case 'operation_success':
      title = 'Operasi Berhasil';
      description = 'Operasi yang Anda lakukan berhasil.';
      break;
    default:
      title = 'Operasi Sukses';
      description = 'Operasi berhasil dilakukan.';
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Loadingbottomsheet(
        title: title,
        description: description,
      );
    },
  ).whenComplete(() {
    // After the bottom sheet is closed, you can add any additional actions if needed
  });


}
