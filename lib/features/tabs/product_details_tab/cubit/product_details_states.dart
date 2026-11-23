import 'package:ecommerce/domain/entities/response/product.dart';

sealed class ProductDetailsStates {}

class ProductDetailsLoadingState extends ProductDetailsStates {}

class ProductDetailsErrorState extends ProductDetailsStates {
  final String message;
  ProductDetailsErrorState({required this.message});
}

class ProductDetailsSuccessState extends ProductDetailsStates {
  final Product product;
  final int quantity;

  ProductDetailsSuccessState({required this.product, required this.quantity});

  bool get isInStock => (product.quantity ?? 0) > 0;

  bool get canIncrement => quantity < (product.quantity ?? 0);

  bool get canDecrement => quantity > 1;

  int get totalPrice => product.finalPrice * quantity;
}
