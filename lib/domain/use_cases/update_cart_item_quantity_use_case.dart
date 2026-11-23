import 'package:ecommerce/domain/entities/response/cart.dart';
import 'package:ecommerce/domain/repos/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateCartItemQuantityUseCase {
  final CartRepo cartRepo;

  UpdateCartItemQuantityUseCase({required this.cartRepo});

  Future<Cart> invoke(String productId, int count) =>
      cartRepo.updateItemQuantity(productId, count);
}
