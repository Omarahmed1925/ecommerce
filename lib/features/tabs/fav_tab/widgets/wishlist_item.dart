import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/widgets/app_network_image.dart';
import 'package:ecommerce/widgets/favorite_button.dart';
import 'package:ecommerce/widgets/price_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const WishlistItem({
    super.key,
    required this.product,
    required this.onTap,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.r),
      child: Container(
        // Min height (not fixed) so larger text or long titles never clip.
        constraints: BoxConstraints(minHeight: 113.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColors.primary300pacity),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: SizedBox(
                  width: 120.w,
                  child: AppNetworkImage(url: product.imageCover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.title ?? '',
                              style: AppStyles.medium16Primary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          FavoriteButton(isFavorite: true, onTap: onRemove),
                        ],
                      ),
                      // Price on the left, action on the right edge. Full
                      // width so spaceBetween has room to work; when space
                      // runs out (narrow screen, large text) the action wraps
                      // below. (Wrap, unlike OverflowBar, reports a correct
                      // intrinsic height for the card's IntrinsicHeight.)
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8.w,
                          runSpacing: 4.h,
                          children: [
                            PriceText(
                              product: product,
                              style: AppStyles.medium16Primary,
                            ),
                            ElevatedButton(
                              onPressed: onAddToCart,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                              ),
                              child: Text(
                                'Add to Cart',
                                style: AppStyles.regular14Primary.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
