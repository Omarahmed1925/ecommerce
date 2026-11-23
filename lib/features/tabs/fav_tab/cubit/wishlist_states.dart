import 'package:ecommerce/domain/entities/response/product.dart';

sealed class WishlistStates {}

class WishlistInitialState extends WishlistStates {}

class WishlistLoadingState extends WishlistStates {}

class WishlistErrorState extends WishlistStates {
  final String message;
  WishlistErrorState({required this.message});
}

class WishlistSuccessState extends WishlistStates {
  final List<Product> products;
  WishlistSuccessState({required this.products});
}

/// One-off feedback (toasts); never rendered by builders.
sealed class WishlistActionState extends WishlistStates {
  final String message;
  WishlistActionState({required this.message});
}

class WishlistActionSuccessState extends WishlistActionState {
  WishlistActionSuccessState({required super.message});
}

class WishlistActionErrorState extends WishlistActionState {
  WishlistActionErrorState({required super.message});
}
