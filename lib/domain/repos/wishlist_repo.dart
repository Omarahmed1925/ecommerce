import 'package:ecommerce/domain/entities/response/product.dart';

abstract class WishlistRepo {
  Future<List<Product>> getWishlist();

  /// Returns the ids of all products in the wishlist after the change.
  Future<List<String>> addToWishlist(String productId);

  /// Returns the ids of all products in the wishlist after the change.
  Future<List<String>> removeFromWishlist(String productId);
}
