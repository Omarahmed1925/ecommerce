import 'package:ecommerce/domain/entities/response/cart.dart';
import 'package:ecommerce/domain/repos/cart_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCartUseCase {
  final CartRepo cartRepo;

  GetCartUseCase({required this.cartRepo});

  Future<Cart> invoke() => cartRepo.getCart();
}
