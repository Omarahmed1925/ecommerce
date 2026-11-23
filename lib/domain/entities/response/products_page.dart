import 'package:ecommerce/domain/entities/response/product.dart';

class ProductsPage {
  final List<Product> products;
  final int currentPage;
  final int numberOfPages;

  ProductsPage({
    required this.products,
    required this.currentPage,
    required this.numberOfPages,
  });

  bool get hasMore => currentPage < numberOfPages;
}
