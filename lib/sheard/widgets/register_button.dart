import 'package:chat_app/sheard/styles/colors.dart';
import 'package:chat_app/sheard/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterButton extends StatelessWidget {
  Color backgroundColor;
  Color textColor;
  String title;
  Function onTab;

  RegisterButton(
      {required this.backgroundColor,
      required this.textColor,
      required this.onTab,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTab();
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18.r)
        ),
        padding: EdgeInsets.symmetric(horizontal: 40.w,vertical: 20.h),
        
        child: Row(
          children: [
            Text(
              title,
              style: registerTextStyle,
            ),
            const Spacer(),
            Icon(Icons.arrow_forward,color: textColor,size: 25.sp)
          ],
        ),
      ),
    );
  }
}
