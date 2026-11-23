import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainError extends StatelessWidget {
  final String? eMessage;
  final VoidCallback? onPress;
  const MainError({super.key, required this.eMessage, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            eMessage ?? 'Something went wrong',
            style: AppStyles.medium14LightPrimary,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          if (onPress != null)
            ElevatedButton(
              onPressed: onPress,
              child: Text('Retry', style: AppStyles.medium14LightPrimary),
            ),
        ],
      ),
    );
  }
}
