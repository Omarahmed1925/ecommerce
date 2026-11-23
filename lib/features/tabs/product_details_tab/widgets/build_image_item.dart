import 'package:ecommerce/widgets/app_network_image.dart';
import 'package:ecommerce/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class BuildImageItem extends StatelessWidget {
  final List<String> productImages;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final double height;

  const BuildImageItem({
    super.key,
    required this.height,
    required this.productImages,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary300pacity),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: productImages.isEmpty
                ? const Center(child: AppNetworkImage(url: null))
                : ImageSlideshow(
                    width: double.infinity,
                    height: height,
                    initialPage: 0,
                    indicatorColor: AppColors.primaryColor,
                    indicatorBackgroundColor: AppColors.primary300pacity,
                    indicatorBottomPadding: 15.h,
                    indicatorPadding: 8.w,
                    indicatorRadius: 5,
                    isLoop: productImages.length > 1,
                    autoPlayInterval: 3000,
                    children: productImages
                        .map(
                          (e) => AppNetworkImage(url: e, fit: BoxFit.contain),
                        )
                        .toList(),
                  ),
          ),
          Positioned(
            top: 16.h,
            right: 16.w,
            child: FavoriteButton(isFavorite: isFavorite, onTap: onFavoriteTap),
          ),
        ],
      ),
    );
  }
}
