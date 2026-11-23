import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/domain/entities/response/cart_item.dart';
import 'package:ecommerce/widgets/app_network_image.dart';
import 'package:ecommerce/widgets/quantity_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final bool enabled;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.enabled,
    required this.onTap,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;
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
                child: Container(
                  width: 120.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary300pacity),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: AppNetworkImage(url: product?.imageCover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 8.h, 4.w, 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product?.title ?? '',
                              style: AppStyles.medium16Primary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Remove from cart',
                            visualDensity: VisualDensity.compact,
                            onPressed: enabled ? onDelete : null,
                            icon: const Icon(
                              Icons.delete_outline,
                              color: AppColors.primaryColor,
                            ),
                          ),
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
                            Text(
                              'EGP ${item.price}',
                              style: AppStyles.medium16Primary,
                            ),
                            QuantityItem(
                              compact: true,
                              quantity: item.count,
                              onIncrement: enabled ? onIncrement : null,
                              onDecrement: enabled ? onDecrement : null,
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
