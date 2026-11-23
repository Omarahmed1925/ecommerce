import 'package:dio/dio.dart';
import 'package:ecommerce/api/mapper/address_mapper.dart';
import 'package:ecommerce/api/web_services.dart';
import 'package:ecommerce/core/exceptions/dio_exception_mapper.dart';
import 'package:ecommerce/data/data_sources/remote/order_remote_data_source.dart';
import 'package:ecommerce/domain/entities/request/shipping_address.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final WebServices webServices;

  OrderRemoteDataSourceImpl({required this.webServices});

  @override
  Future<void> createCashOrder(String cartId, ShippingAddress address) async {
    try {
      await webServices.createCashOrder(
        cartId,
        address.toShippingAddressRequestDto(),
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}
