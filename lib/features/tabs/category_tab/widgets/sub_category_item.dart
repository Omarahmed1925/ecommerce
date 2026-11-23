import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/domain/entities/response/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The subcategories API returns no image, so a neutral tile is shown.
class SubCategoryItem extends StatelessWidget {
  final Subcategory subCategory;
  final VoidCallback onTap;

  const SubCategoryItem({
    super.key,
    required this.subCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.sidebarColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.category_outlined,
                color: AppColors.primaryColor,
                size: 28.sp,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            subCategory.name ?? '',
            style: AppStyles.regular12Primary,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
