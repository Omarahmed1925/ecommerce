import 'package:ecommerce/domain/entities/response/cart.dart';
import 'package:ecommerce/domain/repos/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveCartItemUseCase {
  final CartRepo cartRepo;

  RemoveCartItemUseCase({required this.cartRepo});

  Future<Cart> invoke(String productId) => cartRepo.removeItem(productId);
}
