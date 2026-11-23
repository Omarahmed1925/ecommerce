import 'package:dio/dio.dart';
import 'package:ecommerce/api/mapper/category_mapper.dart';
import 'package:ecommerce/core/exceptions/dio_exception_mapper.dart';
import 'package:ecommerce/data/data_sources/remote/brands_remote_data_source.dart';
import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:injectable/injectable.dart';

import '../../web_services.dart';

@Injectable(as: BrandsRemoteDataSource)
class BrandsRemoteDataSourceImpl implements BrandsRemoteDataSource {
  WebServices webServices;
  BrandsRemoteDataSourceImpl({required this.webServices});
  @override
  Future<List<Category>?> getAllBrands() async {
    try {
      final brandsResponse = await webServices.getAllBrands();
      return brandsResponse.data?.map((dto) => dto.toCategory()).toList() ?? [];
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}
