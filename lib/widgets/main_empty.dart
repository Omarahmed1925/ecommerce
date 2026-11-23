import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainEmpty extends StatelessWidget {
  final String message;
  final IconData icon;

  const MainEmpty({
    super.key,
    required this.message,
    this.icon = Icons.inventory_2_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64.sp, color: AppColors.primary300pacity),
            SizedBox(height: 12.h),
            Text(
              message,
              style: AppStyles.medium16Primary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
