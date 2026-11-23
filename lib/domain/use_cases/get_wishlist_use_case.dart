import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/domain/repos/wishlist_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetWishlistUseCase {
  final WishlistRepo wishlistRepo;

  GetWishlistUseCase({required this.wishlistRepo});

  Future<List<Product>> invoke() => wishlistRepo.getWishlist();
}
