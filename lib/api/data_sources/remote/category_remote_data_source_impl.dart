import 'package:dio/dio.dart';
import 'package:ecommerce/api/mapper/category_mapper.dart';
import 'package:ecommerce/api/mapper/sub_category_mapper.dart';
import 'package:ecommerce/api/web_services.dart';
import 'package:ecommerce/core/exceptions/dio_exception_mapper.dart';
import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/entities/response/sub_category.dart';
import 'package:injectable/injectable.dart';

import '../../../data/data_sources/remote/category_remote_data_source.dart';

@Injectable(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final WebServices webServices;
  CategoryRemoteDataSourceImpl(this.webServices);

  @override
  Future<List<Category>?> getAllCategories() async {
    try {
      final categoryResponse = await webServices.getAllCategories();
      return categoryResponse.data?.map((dto) => dto.toCategory()).toList() ??
          [];
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<Subcategory>> getSubCategories(String categoryId) async {
    try {
      final response = await webServices.getSubCategoriesOnCategory(categoryId);
      // The endpoint currently returns every subcategory regardless of the
      // id in the path, so keep only the ones belonging to this category.
      return response.data
              ?.where((dto) => dto.category == categoryId)
              .map((dto) => dto.toSubCategory())
              .toList() ??
          [];
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}
