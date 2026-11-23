import 'package:ecommerce/domain/entities/response/product.dart';

class CartItem {
  final String? id;
  final int count;
  final int price;
  final Product? product;

  CartItem({
    required this.id,
    required this.count,
    required this.price,
    required this.product,
  });
}
