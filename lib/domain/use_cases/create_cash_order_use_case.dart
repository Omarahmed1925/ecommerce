import 'package:ecommerce/domain/entities/request/shipping_address.dart';
import 'package:ecommerce/domain/repos/order_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateCashOrderUseCase {
  final OrderRepo orderRepo;

  CreateCashOrderUseCase({required this.orderRepo});

  Future<void> invoke(String cartId, ShippingAddress address) =>
      orderRepo.createCashOrder(cartId, address);
}
