import 'package:ecommerce/core/utils/app_assets.dart';
import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantityItem extends StatelessWidget {
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final bool compact;

  const QuantityItem({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 18.sp : 24.sp;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.primaryColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: compact ? VisualDensity.compact : null,
            iconSize: iconSize,
            tooltip: 'Decrease quantity',
            onPressed: onDecrement,
            icon: const ImageIcon(
              AssetImage(AppAssets.removeImage),
              color: AppColors.whiteColor,
            ),
          ),
          Text(
            '$quantity',
            style: compact
                ? AppStyles.semi16TextWhite
                : AppStyles.medium18White,
          ),
          IconButton(
            visualDensity: compact ? VisualDensity.compact : null,
            iconSize: iconSize,
            tooltip: 'Increase quantity',
            onPressed: onIncrement,
            icon: const ImageIcon(
              AssetImage(AppAssets.addImage),
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
