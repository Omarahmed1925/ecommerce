import 'package:ecommerce/widgets/responsive_center.dart';
import 'package:ecommerce/core/utils/app_assets.dart';
import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/features/tabs/cart_tab/cubit/cart_view_model.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_states.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_view_model.dart';
import 'package:ecommerce/features/tabs/fav_tab/widgets/wishlist_item.dart';
import 'package:ecommerce/widgets/custom_search_row.dart';
import 'package:ecommerce/widgets/main_empty.dart';
import 'package:ecommerce/widgets/main_error.dart';
import 'package:ecommerce/widgets/main_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Rendered from the app-wide [WishlistViewModel], which the home screen
/// loads on start and keeps in sync with every heart toggle.
class FavsTab extends StatefulWidget {
  const FavsTab({super.key});

  @override
  State<FavsTab> createState() => _FavsTabState();
}

class _FavsTabState extends State<FavsTab> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<WishlistViewModel>();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Image.asset(AppAssets.routeSmallLogo),
      ),
      body: ResponsiveCenter(
        child: Column(
          children: [
            CustomSearchRow(searchController: searchController),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<WishlistViewModel, WishlistStates>(
                buildWhen: (previous, current) =>
                    current is! WishlistActionState,
                builder: (context, state) => switch (state) {
                  WishlistErrorState() => MainError(
                    eMessage: state.message,
                    onPress: viewModel.getWishlist,
                  ),
                  WishlistSuccessState() => RefreshIndicator(
                    color: AppColors.primaryColor,
                    onRefresh: viewModel.getWishlist,
                    child: state.products.isEmpty
                        ? ListView(
                            children: const [
                              MainEmpty(
                                message: 'Your wishlist is empty',
                                icon: Icons.favorite_border,
                              ),
                            ],
                          )
                        : _buildList(state.products),
                  ),
                  _ => const MainLoading(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Product> products) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: 16.h),
      itemCount: products.length,
      separatorBuilder: (_, _) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final product = products[index];
        return WishlistItem(
          product: product,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.productDetails,
            arguments: product.id,
          ),
          onRemove: () =>
              context.read<WishlistViewModel>().toggleFavorite(product),
          onAddToCart: () {
            final id = product.id;
            if (id != null) context.read<CartViewModel>().addToCart(id);
          },
        );
      },
    );
  }
}
