import 'package:flutter/material.dart';

class TextFieldCoustume extends StatelessWidget {
  IconData icon;
  IconData? suffixIcon;
  String hintText;
  bool? obscureText;
  TextFieldCoustume(
      {required this.hintText,
      required this.icon,
      this.suffixIcon,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        hintText: "$hintText",
        prefixIcon: Icon(icon),
        suffixIcon: Icon(suffixIcon),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
