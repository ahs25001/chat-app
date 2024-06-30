import 'package:flutter/material.dart';

import '../styles/colors.dart';

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