import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';

class SelectImageSourceDialog extends StatelessWidget {
  const SelectImageSourceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.camera_alt, size: 40.sp, color: primaryColor),
          Icon(Icons.image, size: 40.sp, color: primaryColor),
        ],
      ),
    ).animate().scale(duration: const Duration(milliseconds: 200),curve:Curves.bounceInOut );
  }
}
