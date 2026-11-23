import 'package:ecommerce/domain/entities/response/cart_item.dart';

class Cart {
  final String? cartId;
  final int numOfCartItems;
  final int totalCartPrice;
  final List<CartItem> items;

  Cart({
    required this.cartId,
    required this.numOfCartItems,
    required this.totalCartPrice,
    required this.items,
  });

  factory Cart.empty() =>
      Cart(cartId: null, numOfCartItems: 0, totalCartPrice: 0, items: const []);
}
