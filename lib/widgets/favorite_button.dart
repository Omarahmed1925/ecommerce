import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isFavorite ? 'Remove from wishlist' : 'Add to wishlist',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          height: 30.r,
          width: 30.r,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 4)],
          ),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: AppColors.primaryColor,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}
