import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/utils/app_colors.dart';

class Customelevatedbutton extends StatelessWidget {
  Customelevatedbutton({
    super.key,
    this.iconExists = false,
    this.text,
    required this.onPressed,
    this.borderSideColor = AppColors.primaryColor,
    this.textStyle,
    this.backgroundColor,
    this.widget,
  });

  bool iconExists;
  Widget? widget;
  String? text;
  VoidCallback onPressed;
  Color borderSideColor;
  TextStyle? textStyle;
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
          side: BorderSide(color: borderSideColor),
        ),
        textStyle: textStyle ?? AppStyles.medium18White,
        backgroundColor: backgroundColor ?? AppColors.whiteColor,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        elevation: 0,
      ),
      child: iconExists
          ? widget
          : Text(text ?? '', style: AppStyles.semi20Primary),
    );
  }
}
