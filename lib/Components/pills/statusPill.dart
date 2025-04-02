import 'package:flutter/material.dart';

Widget StatusPill(String status) {
  Color backgroundColor;
  Color textColor;

  // Tentukan warna berdasarkan status
  switch (status.toLowerCase()) {
    case 'pending':
      backgroundColor = Colors.orange[100]!;
      textColor = Colors.orange[800]!;
      break;
    case 'pesanan diproses':
      backgroundColor = Colors.blue[100]!;
      textColor = Colors.blue[800]!;
      break;
    case 'pesanan selesai':
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[800]!;
      break;
    case 'pesanan dibatalkan':
      backgroundColor = Colors.red[100]!;
      textColor = Colors.red[800]!;
      break;
    default:
      backgroundColor = Colors.grey[200]!;
      textColor = Colors.grey[800]!;
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}
