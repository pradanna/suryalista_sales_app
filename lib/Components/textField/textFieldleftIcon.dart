import 'package:flutter/material.dart';

Widget buildTextFieldWithIcon(
    IconData iconData,
    String labelText, {
      ValueChanged<String>? onChanged,
      bool obscureText = false,
      Color borderColor = Colors.black, // Default border color
    }) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(iconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor), // Border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor), // Focused border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor.withOpacity(0.2)), // Enabled border color
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black), // Error border color
        ),
      ),
      obscureText: obscureText,
    ),
  );
}