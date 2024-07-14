import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/styles.dart';

void doLoading(BuildContext context){
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        content: Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      ),
    ),
  );
}
void showSuccessSnackBar({required BuildContext context , required String text}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      style: registerTextStyle.copyWith(color: Colors.white),
    ),
    backgroundColor: Colors.green,
  ));
}void showErrorSnackBar({required BuildContext context , required String text}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      text,
      style: registerTextStyle.copyWith(color: Colors.white),
    ),
    backgroundColor: Colors.red,
  ));
}