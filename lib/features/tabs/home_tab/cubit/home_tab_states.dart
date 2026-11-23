import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/entities/response/product.dart';

sealed class HomeTabState {}

final class HomeTabInitial extends HomeTabState {}

final class HomeTabLoading extends HomeTabState {}

final class HomeTabSuccess extends HomeTabState {
  final List<Category> categories;
  final List<Category> brands;
  final List<Product> bestSellers;

  HomeTabSuccess({
    required this.categories,
    required this.brands,
    required this.bestSellers,
  });
}

final class HomeTabFailure extends HomeTabState {
  final String? errorMessage;
  HomeTabFailure({required this.errorMessage});
}
