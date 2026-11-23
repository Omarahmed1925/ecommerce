import 'package:ecommerce/config/di/di.dart';
import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/features/tabs/cart_tab/cubit/cart_view_model.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_states.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_view_model.dart';
import 'package:ecommerce/features/tabs/product_details_tab/cubit/product_details_states.dart';
import 'package:ecommerce/features/tabs/product_details_tab/cubit/product_details_view_model.dart';
import 'package:ecommerce/features/tabs/product_details_tab/widgets/add_to_cart_item.dart';
import 'package:ecommerce/features/tabs/product_details_tab/widgets/build_image_item.dart';
import 'package:ecommerce/features/tabs/product_details_tab/widgets/sold_item.dart';
import 'package:ecommerce/widgets/adaptive_two_pane.dart';
import 'package:ecommerce/widgets/app_bar_item.dart';
import 'package:ecommerce/widgets/main_error.dart';
import 'package:ecommerce/widgets/main_loading.dart';
import 'package:ecommerce/widgets/price_text.dart';
import 'package:ecommerce/widgets/quantity_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

/// Route argument: the product id (`String`).
class ProductDetailsTab extends StatefulWidget {
  const ProductDetailsTab({super.key});

  @override
  State<ProductDetailsTab> createState() => _ProductDetailsTabState();
}

class _ProductDetailsTabState extends State<ProductDetailsTab> {
  final ProductDetailsViewModel viewModel = getIt<ProductDetailsViewModel>();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final productId = ModalRoute.of(context)?.settings.arguments;
    if (productId is String) {
      viewModel.init(productId);
    }
  }

  @override
  void dispose() {
    viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarItem(title: 'Product Details'),
      body: BlocBuilder<ProductDetailsViewModel, ProductDetailsStates>(
        bloc: viewModel,
        builder: (context, state) => switch (state) {
          ProductDetailsErrorState() => MainError(
            eMessage: state.message,
            onPress: viewModel.getProduct,
          ),
          ProductDetailsSuccessState() => _buildContent(state),
          ProductDetailsLoadingState() => const MainLoading(),
        },
      ),
    );
  }

  Widget _buildContent(ProductDetailsSuccessState state) {
    // Compact (folded phone): one scrolling column.
    // Wider (unfolded foldable, landscape, tablet): image on one half and
    // details on the other, split on the hinge when there is one.
    if (WindowSizeClass.of(context).isCompact) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(state, height: 300.h),
                    SizedBox(height: 24.h),
                    _buildInfo(state),
                  ],
                ),
              ),
            ),
            _buildBottomBar(state),
          ],
        ),
      );
    }
    return AdaptiveTwoPane(
      start: SafeArea(
        right: false,
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: LayoutBuilder(
            builder: (context, constraints) =>
                _buildImage(state, height: constraints.maxHeight),
          ),
        ),
      ),
      end: SafeArea(
        left: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 16.h),
                  child: _buildInfo(state),
                ),
              ),
              _buildBottomBar(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(
    ProductDetailsSuccessState state, {
    required double height,
  }) {
    final product = state.product;
    return BlocSelector<WishlistViewModel, WishlistStates, bool>(
      selector: (_) => context.read<WishlistViewModel>().isFavorite(product.id),
      builder: (context, isFavorite) => BuildImageItem(
        height: height,
        productImages:
            product.images ??
            [if (product.imageCover != null) product.imageCover!],
        isFavorite: isFavorite,
        onFavoriteTap: () =>
            context.read<WishlistViewModel>().toggleFavorite(product),
      ),
    );
  }

  Widget _buildInfo(ProductDetailsSuccessState state) {
    final product = state.product;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(product.title ?? '', style: AppStyles.medium18Header),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: PriceText(
                product: product,
                style: AppStyles.medium18Header,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildStatsRow(state),
        SizedBox(height: 16.h),
        Text('Description', style: AppStyles.medium18Header),
        SizedBox(height: 8.h),
        ReadMoreText(
          product.description ?? '',
          style: AppStyles.regular14Primary.copyWith(
            color: AppColors.primaryColor.withValues(alpha: 0.6),
          ),
          trimMode: TrimMode.Line,
          trimLines: 3,
          colorClickableText: AppColors.primaryColor,
          trimCollapsedText: ' Read More',
          trimExpandedText: ' Read less',
          moreStyle: AppStyles.medium14LightPrimary,
          lessStyle: AppStyles.medium14LightPrimary,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildStatsRow(ProductDetailsSuccessState state) {
    final product = state.product;
    return Row(
      children: [
        SoldItem(price: '${product.sold ?? 0}'),
        SizedBox(width: 12.w),
        Icon(Icons.star, color: AppColors.yellowColor, size: 18.sp),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            '${product.ratingsAverage ?? '-'} (${product.ratingsQuantity ?? 0})',
            style: AppStyles.regular14Primary,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (state.isInStock)
          QuantityItem(
            compact: true,
            quantity: state.quantity,
            onDecrement: state.canDecrement ? viewModel.decrement : null,
            onIncrement: state.canIncrement ? viewModel.increment : null,
          )
        else
          Text(
            'Out of stock',
            style: AppStyles.medium14LightPrimary.copyWith(
              color: AppColors.redColor,
            ),
          ),
      ],
    );
  }

  Widget _buildBottomBar(ProductDetailsSuccessState state) {
    final productId = state.product.id;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total price', style: AppStyles.regular14Gray),
                SizedBox(height: 4.h),
                Text('EGP ${state.totalPrice}', style: AppStyles.semi18Primary),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AddToCartItem(
                onTap: state.isInStock && productId != null
                    ? () => context.read<CartViewModel>().addToCart(
                        productId,
                        quantity: state.quantity,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
