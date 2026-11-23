import 'package:ecommerce/domain/entities/response/cart.dart';
import 'package:ecommerce/domain/repos/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddToCartUseCase {
  final CartRepo cartRepo;

  AddToCartUseCase({required this.cartRepo});

  Future<Cart> invoke(String productId) => cartRepo.addToCart(productId);
}
