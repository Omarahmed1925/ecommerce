import 'package:ecommerce/domain/entities/response/product.dart';

sealed class ProductListStates {}

class ProductListLoadingState extends ProductListStates {}

class ProductListErrorState extends ProductListStates {
  final String message;
  ProductListErrorState({required this.message});
}

class ProductListEmptyState extends ProductListStates {}

class ProductListSuccessState extends ProductListStates {
  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;
  final String? loadMoreError;

  ProductListSuccessState({
    required this.products,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreError,
  });
}
