import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/widgets/app_network_image.dart';
import 'package:ecommerce/widgets/favorite_button.dart';
import 'package:ecommerce/widgets/price_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItem extends StatelessWidget {
  final Product prod;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddToCart;

  const ProductItem({
    super.key,
    required this.prod,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColors.primary300pacity, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(13.r),
                      ),
                      child: AppNetworkImage(url: prod.imageCover),
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: FavoriteButton(
                      isFavorite: isFavorite,
                      onTap: onFavoriteTap,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prod.title ?? '',
                    style: AppStyles.regular14Primary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    prod.description ?? '',
                    style: AppStyles.regular12Primary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  PriceText(product: prod),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 0, 4.w, 4.h),
              child: Row(
                children: [
                  // The rating group gets all the width up to the button
                  // (a Flexible + Spacer pair split it in half and truncated
                  // "Review (4.8)" to "Review ...").
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Review (${prod.ratingsAverage ?? '-'})',
                            style: AppStyles.regular12Primary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.star,
                          color: AppColors.yellowColor,
                          size: 15.sp,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Add to cart',
                    visualDensity: VisualDensity.compact,
                    onPressed: onAddToCart,
                    icon: Container(
                      height: 30.r,
                      width: 30.r,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: AppColors.whiteColor,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
