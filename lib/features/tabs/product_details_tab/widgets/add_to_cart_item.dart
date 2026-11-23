import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddToCartItem extends StatelessWidget {
  /// `null` disables the button (e.g. out of stock).
  final VoidCallback? onTap;
  final String label;

  const AddToCartItem({
    super.key,
    required this.onTap,
    this.label = 'Add to cart',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        disabledBackgroundColor: AppColors.grayColor,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      icon: const Icon(
        Icons.add_shopping_cart_outlined,
        color: AppColors.whiteColor,
      ),
      label: Text(label, style: AppStyles.medium18White),
    );
  }
}
