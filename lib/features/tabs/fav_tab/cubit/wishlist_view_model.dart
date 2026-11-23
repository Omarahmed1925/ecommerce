import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/domain/use_cases/add_to_wishlist_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_wishlist_use_case.dart';
import 'package:ecommerce/domain/use_cases/remove_from_wishlist_use_case.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_states.dart';
import 'package:injectable/injectable.dart';

/// App-wide: product cards on every screen read [isFavorite] from here.
@lazySingleton
class WishlistViewModel extends Cubit<WishlistStates> {
  final GetWishlistUseCase getWishlistUseCase;
  final AddToWishlistUseCase addToWishlistUseCase;
  final RemoveFromWishlistUseCase removeFromWishlistUseCase;

  WishlistViewModel({
    required this.getWishlistUseCase,
    required this.addToWishlistUseCase,
    required this.removeFromWishlistUseCase,
  }) : super(WishlistInitialState());

  final Set<String> _favoriteIds = {};
  List<Product> _products = [];

  bool isFavorite(String? productId) =>
      productId != null && _favoriteIds.contains(productId);

  Future<void> getWishlist() async {
    emit(WishlistLoadingState());
    try {
      _products = await getWishlistUseCase.invoke();
      _favoriteIds
        ..clear()
        ..addAll(_products.map((p) => p.id).whereType<String>());
      emit(WishlistSuccessState(products: List.of(_products)));
    } on AppExceptions catch (e) {
      emit(WishlistErrorState(message: e.message));
    }
  }

  Future<void> toggleFavorite(Product product) async {
    final id = product.id;
    if (id == null) return;
    final wasFavorite = isFavorite(id);
    final previousIds = Set.of(_favoriteIds);
    final previousProducts = List.of(_products);

    // Optimistic update so hearts react immediately.
    if (wasFavorite) {
      _favoriteIds.remove(id);
      _products.removeWhere((p) => p.id == id);
    } else {
      _favoriteIds.add(id);
      _products.add(product);
    }
    emit(WishlistSuccessState(products: List.of(_products)));

    try {
      final ids = wasFavorite
          ? await removeFromWishlistUseCase.invoke(id)
          : await addToWishlistUseCase.invoke(id);
      if (ids.isNotEmpty || wasFavorite) {
        _favoriteIds
          ..clear()
          ..addAll(ids);
        _products.removeWhere((p) => !_favoriteIds.contains(p.id));
      }
      emit(
        WishlistActionSuccessState(
          message: wasFavorite ? 'Removed from wishlist' : 'Added to wishlist',
        ),
      );
    } on AppExceptions catch (e) {
      _favoriteIds
        ..clear()
        ..addAll(previousIds);
      _products = previousProducts;
      emit(WishlistActionErrorState(message: e.message));
    }
    emit(WishlistSuccessState(products: List.of(_products)));
  }

  void reset() {
    _favoriteIds.clear();
    _products = [];
    emit(WishlistInitialState());
  }
}
