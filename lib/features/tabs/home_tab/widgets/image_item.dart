import 'package:ecommerce/core/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class ImageItem extends StatelessWidget {
  const ImageItem({super.key});

  static const List<String> images = [
    AppAssets.adImage1,
    AppAssets.adImage2,
    AppAssets.adImage3,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Follows the banner's aspect ratio on phones, but stops growing on
        // wide (unfolded) screens so it doesn't push content off-screen.
        final height = (constraints.maxWidth * 0.44).clamp(140.0, 260.0);
        return ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: ImageSlideshow(
            width: double.infinity,
            height: height,
            initialPage: 0,
            indicatorColor: AppColors.primaryColor,
            indicatorBackgroundColor: AppColors.primary300pacity,
            indicatorBottomPadding: 15.h,
            indicatorPadding: 8.w,
            indicatorRadius: 5,
            isLoop: true,
            autoPlayInterval: 3000,
            children: images
                .map((e) => Image.asset(e, fit: BoxFit.cover))
                .toList(),
          ),
        );
      },
    );
  }
}
