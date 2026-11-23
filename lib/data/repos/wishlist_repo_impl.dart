import 'package:ecommerce/data/data_sources/remote/wishlist_remote_data_source.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/domain/repos/wishlist_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WishlistRepo)
class WishlistRepoImpl implements WishlistRepo {
  final WishlistRemoteDataSource wishlistRemoteDataSource;

  WishlistRepoImpl({required this.wishlistRemoteDataSource});

  @override
  Future<List<Product>> getWishlist() => wishlistRemoteDataSource.getWishlist();

  @override
  Future<List<String>> addToWishlist(String productId) =>
      wishlistRemoteDataSource.addToWishlist(productId);

  @override
  Future<List<String>> removeFromWishlist(String productId) =>
      wishlistRemoteDataSource.removeFromWishlist(productId);
}
