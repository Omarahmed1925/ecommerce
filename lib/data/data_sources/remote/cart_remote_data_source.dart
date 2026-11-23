import 'package:ecommerce/domain/entities/response/cart.dart';

abstract class CartRemoteDataSource {
  Future<Cart> getCart();
  Future<Cart> addToCart(String productId);
  Future<Cart> updateItemQuantity(String productId, int count);
  Future<Cart> removeItem(String productId);
}
