import 'package:chat_app/sheard/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';

class CreateChatField extends StatelessWidget {
  String label;
  TextEditingController controller;
  Function validator;

  CreateChatField(
      {required this.label, required this.controller, required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        return validator(value);
      },
      controller: controller,
      decoration: InputDecoration(
          label: Text(
            label,
            style: labelStyle,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(color: primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(color: primaryColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.r),
              borderSide: BorderSide(color: labelColor))),
    );
  }
}
