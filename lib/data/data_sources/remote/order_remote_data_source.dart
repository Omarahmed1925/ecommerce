import 'package:ecommerce/domain/entities/request/shipping_address.dart';

abstract class OrderRemoteDataSource {
  Future<void> createCashOrder(String cartId, ShippingAddress address);
}
