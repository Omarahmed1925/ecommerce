import 'package:ecommerce/domain/entities/response/category.dart';

abstract class BrandsRemoteDataSource {
  Future<List<Category>?> getAllBrands();
}
