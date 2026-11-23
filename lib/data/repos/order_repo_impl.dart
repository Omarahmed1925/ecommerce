import 'package:ecommerce/data/data_sources/remote/order_remote_data_source.dart';
import 'package:ecommerce/domain/entities/request/shipping_address.dart';
import 'package:ecommerce/domain/repos/order_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrderRepo)
class OrderRepoImpl implements OrderRepo {
  final OrderRemoteDataSource orderRemoteDataSource;

  OrderRepoImpl({required this.orderRemoteDataSource});

  @override
  Future<void> createCashOrder(String cartId, ShippingAddress address) =>
      orderRemoteDataSource.createCashOrder(cartId, address);
}
