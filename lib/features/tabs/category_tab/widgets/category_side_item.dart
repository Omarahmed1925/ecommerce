import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategorySideItem extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategorySideItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: isSelected ? AppColors.whiteColor : AppColors.transparentColor,
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Row(
            children: [
              Container(
                width: 6.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.transparentColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  category.name ?? '',
                  style: isSelected
                      ? AppStyles.medium14LightPrimary
                      : AppStyles.regular14Primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
