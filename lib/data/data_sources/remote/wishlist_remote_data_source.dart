import 'package:ecommerce/domain/entities/response/product.dart';

abstract class WishlistRemoteDataSource {
  Future<List<Product>> getWishlist();
  Future<List<String>> addToWishlist(String productId);
  Future<List<String>> removeFromWishlist(String productId);
}
