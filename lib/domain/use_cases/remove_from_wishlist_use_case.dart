import 'package:ecommerce/domain/repos/wishlist_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveFromWishlistUseCase {
  final WishlistRepo wishlistRepo;

  RemoveFromWishlistUseCase({required this.wishlistRepo});

  Future<List<String>> invoke(String productId) =>
      wishlistRepo.removeFromWishlist(productId);
}
