import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/styles.dart';

class CustomField extends StatelessWidget {
  TextEditingController controller;
  bool isPassword;
  bool isPasswordVisible;
  String label;
  Function validator;
  Function? changeVisibility;

  CustomField(
      {required this.controller,
      required this.isPassword,
      required this.label,
      this.changeVisibility,
      this.isPasswordVisible = false,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword && !isPasswordVisible,
      controller: controller,
      keyboardType: (isPassword)?TextInputType.visiblePassword:TextInputType.emailAddress,
      validator: (value) => validator(value),
      cursorColor: primaryColor,
      decoration: InputDecoration(
          suffixIcon: isPassword
              ? InkWell(
                  splashColor: Colors.transparent,
                  onTap: () => changeVisibility!(),
                  child: Icon(
                    (isPasswordVisible)
                        ? Icons.visibility_off
                        : Icons.remove_red_eye,
                    color: primaryColor,
                  ),
                )
              : null,
          label: Text(
            label,
            style: labelStyle,
          ),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor))),
    );
  }
}
