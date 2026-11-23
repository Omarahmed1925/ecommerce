import 'package:ecommerce/domain/repos/wishlist_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddToWishlistUseCase {
  final WishlistRepo wishlistRepo;

  AddToWishlistUseCase({required this.wishlistRepo});

  Future<List<String>> invoke(String productId) =>
      wishlistRepo.addToWishlist(productId);
}
