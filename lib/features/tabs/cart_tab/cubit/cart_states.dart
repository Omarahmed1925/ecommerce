import 'package:ecommerce/domain/entities/response/cart.dart';

sealed class CartStates {}

class CartInitialState extends CartStates {}

class CartLoadingState extends CartStates {}

class CartErrorState extends CartStates {
  final String message;
  CartErrorState({required this.message});
}

class CartSuccessState extends CartStates {
  final Cart cart;
  final bool isUpdating;
  CartSuccessState({required this.cart, this.isUpdating = false});
}

/// One-off feedback (toasts); never rendered by builders.
sealed class CartActionState extends CartStates {
  final String message;
  CartActionState({required this.message});
}

class CartActionSuccessState extends CartActionState {
  CartActionSuccessState({required super.message});
}

class CartActionErrorState extends CartActionState {
  CartActionErrorState({required super.message});
}
