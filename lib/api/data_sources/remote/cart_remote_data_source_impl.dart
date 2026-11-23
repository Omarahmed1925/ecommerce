import 'package:dio/dio.dart';
import 'package:ecommerce/api/mapper/cart_mapper.dart';
import 'package:ecommerce/api/model/request/cart_quantity_request_dto.dart';
import 'package:ecommerce/api/model/request/product_request_dto.dart';
import 'package:ecommerce/api/web_services.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/core/exceptions/dio_exception_mapper.dart';
import 'package:ecommerce/data/data_sources/remote/cart_remote_data_source.dart';
import 'package:ecommerce/domain/entities/response/cart.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRemoteDataSource)
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final WebServices webServices;

  CartRemoteDataSourceImpl({required this.webServices});

  @override
  Future<Cart> getCart() async {
    try {
      final response = await webServices.getCart();
      return response.toCart();
    } on DioException catch (e) {
      final exception = e.toAppException();
      // A user who never added anything has no cart yet (404).
      if (exception is ServerException && exception.statusCode == 404) {
        return Cart.empty();
      }
      throw exception;
    }
  }

  @override
  Future<Cart> addToCart(String productId) async {
    try {
      final response = await webServices.addToCart(
        ProductRequestDto(productId: productId),
      );
      return response.toCart();
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<Cart> updateItemQuantity(String productId, int count) async {
    try {
      final response = await webServices.updateCartItemQuantity(
        productId,
        CartQuantityRequestDto(count: count.toString()),
      );
      return response.toCart();
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<Cart> removeItem(String productId) async {
    try {
      final response = await webServices.removeCartItem(productId);
      return response.toCart();
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}
