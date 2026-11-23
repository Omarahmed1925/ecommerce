import 'package:ecommerce/domain/entities/request/shipping_address.dart';

abstract class OrderRepo {
  Future<void> createCashOrder(String cartId, ShippingAddress address);
}
