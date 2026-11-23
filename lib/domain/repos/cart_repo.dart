import 'package:ecommerce/domain/entities/response/cart.dart';

abstract class CartRepo {
  Future<Cart> getCart();
  Future<Cart> addToCart(String productId);
  Future<Cart> updateItemQuantity(String productId, int count);
  Future<Cart> removeItem(String productId);
}
