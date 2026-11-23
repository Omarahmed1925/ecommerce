import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/entities/response/sub_category.dart';

abstract class CategoryRemoteDataSource {
  Future<List<Category>?> getAllCategories();
  Future<List<Subcategory>> getSubCategories(String categoryId);
}
