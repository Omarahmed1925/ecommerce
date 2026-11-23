import 'package:ecommerce/widgets/responsive_center.dart';
import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/domain/entities/response/cart.dart';
import 'package:ecommerce/features/tabs/cart_tab/cubit/cart_states.dart';
import 'package:ecommerce/features/tabs/cart_tab/cubit/cart_view_model.dart';
import 'package:ecommerce/features/tabs/cart_tab/widgets/cart_item_widget.dart';
import 'package:ecommerce/widgets/app_bar_item.dart';
import 'package:ecommerce/widgets/main_empty.dart';
import 'package:ecommerce/widgets/main_error.dart';
import 'package:ecommerce/widgets/main_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  @override
  void initState() {
    super.initState();
    context.read<CartViewModel>().getCart();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CartViewModel>();
    return Scaffold(
      appBar: const AppBarItem(title: 'Cart', showCartAction: false),
      body: ResponsiveCenter(
        child: BlocBuilder<CartViewModel, CartStates>(
          buildWhen: (previous, current) => current is! CartActionState,
          builder: (context, state) => switch (state) {
            CartErrorState() => MainError(
              eMessage: state.message,
              onPress: viewModel.getCart,
            ),
            CartSuccessState() =>
              state.cart.items.isEmpty
                  ? const MainEmpty(
                      message: 'Your cart is empty',
                      icon: Icons.shopping_cart_outlined,
                    )
                  : _buildCart(viewModel, state.cart, state.isUpdating),
            _ => const MainLoading(),
          },
        ),
      ),
    );
  }

  Widget _buildCart(CartViewModel viewModel, Cart cart, bool isUpdating) {
    return Column(
      children: [
        if (isUpdating)
          const LinearProgressIndicator(color: AppColors.primaryColor),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: cart.items.length,
            separatorBuilder: (_, _) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              final productId = item.product?.id;
              return CartItemWidget(
                item: item,
                enabled: !isUpdating && productId != null,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.productDetails,
                  arguments: productId,
                ),
                onDelete: () => viewModel.removeItem(productId!),
                onIncrement: () =>
                    viewModel.updateQuantity(productId!, item.count + 1),
                onDecrement: () =>
                    viewModel.updateQuantity(productId!, item.count - 1),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total price', style: AppStyles.regular14Gray),
                    SizedBox(height: 4.h),
                    Text(
                      'EGP ${cart.totalCartPrice}',
                      style: AppStyles.semi18Primary,
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isUpdating ? null : viewModel.checkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Check Out', style: AppStyles.medium18White),
                        SizedBox(width: 12.w),
                        const Icon(
                          Icons.arrow_forward,
                          color: AppColors.whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
