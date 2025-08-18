import 'package:flutter/material.dart';

class CoustemTextFormFiled extends StatelessWidget {
  final IconData? icon;
  final IconData? suffixIcon;
  final String? hintText;
  final Function(String)? onchanged;
  final String? Function(String?)? validator;
  final bool obsecure;
  final bool password;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  CoustemTextFormFiled({
    this.onchanged,
    this.validator,
    required this.hintText,
    this.obsecure = false,
    this.password = false,
    this.controller,
    this.textInputType = TextInputType.text,
    this.suffixIcon,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      obscureText: obsecure,
      validator: validator,
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
