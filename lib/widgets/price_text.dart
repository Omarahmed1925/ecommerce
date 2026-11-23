import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Final price, plus the original price struck through when discounted.
class PriceText extends StatelessWidget {
  final Product product;
  final TextStyle? style;

  const PriceText({super.key, required this.product, this.style});

  @override
  Widget build(BuildContext context) {
    final priceStyle = style ?? AppStyles.regular14Primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            'EGP ${product.finalPrice}',
            style: priceStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (product.hasDiscount) ...[
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              '${product.price} EGP',
              style: AppStyles.regular12Primary.copyWith(
                color: AppColors.primaryColor.withValues(alpha: 0.6),
                decoration: TextDecoration.lineThrough,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}
