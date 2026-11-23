import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/features/tabs/cart_tab/cubit/cart_view_model.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_states.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_view_model.dart';
import 'package:ecommerce/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [ProductItem] wired to the app-wide wishlist/cart view models.
/// Only the heart rebuilds when the wishlist changes.
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WishlistViewModel, WishlistStates, bool>(
      selector: (_) => context.read<WishlistViewModel>().isFavorite(product.id),
      builder: (context, isFavorite) => ProductItem(
        prod: product,
        isFavorite: isFavorite,
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.productDetails,
          arguments: product.id,
        ),
        onFavoriteTap: () =>
            context.read<WishlistViewModel>().toggleFavorite(product),
        onAddToCart: () {
          final id = product.id;
          if (id != null) context.read<CartViewModel>().addToCart(id);
        },
      ),
    );
  }
}
