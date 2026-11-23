import 'package:ecommerce/domain/entities/response/category.dart';

abstract class BrandsRepo {
  Future<List<Category>?> getAllBrands();
}
