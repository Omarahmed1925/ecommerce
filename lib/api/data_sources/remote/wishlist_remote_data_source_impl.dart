import 'package:dio/dio.dart';
import 'package:ecommerce/api/mapper/product_mapper.dart';
import 'package:ecommerce/api/model/request/product_request_dto.dart';
import 'package:ecommerce/api/model/response/wishlist/wishlist_response_dto.dart';
import 'package:ecommerce/api/web_services.dart';
import 'package:ecommerce/core/exceptions/dio_exception_mapper.dart';
import 'package:ecommerce/data/data_sources/remote/wishlist_remote_data_source.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: WishlistRemoteDataSource)
class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final WebServices webServices;

  WishlistRemoteDataSourceImpl({required this.webServices});

  @override
  Future<List<Product>> getWishlist() async {
    try {
      final response = await webServices.getWishlist();
      return response.data?.map((dto) => dto.toProduct()).toList() ?? [];
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<String>> addToWishlist(String productId) async {
    try {
      final response = await webServices.addToWishlist(
        ProductRequestDto(productId: productId),
      );
      return _ids(response);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<String>> removeFromWishlist(String productId) async {
    try {
      final response = await webServices.removeFromWishlist(productId);
      return _ids(response);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  List<String> _ids(WishlistResponseDto response) =>
      response.data?.map((dto) => dto.id).whereType<String>().toList() ?? [];
}
