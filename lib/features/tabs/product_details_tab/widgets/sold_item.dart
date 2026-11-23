import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_textstyles.dart';

class SoldItem extends StatelessWidget {
  final String price;
  const SoldItem({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    // Sized by its padding, not a fixed box, so it never clips larger text.
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grayColor, width: 1),
      ),
      child: Text("$price Sold", style: AppStyles.medium14LightPrimary),
    );
  }
}
