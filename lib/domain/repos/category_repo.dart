import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/entities/response/sub_category.dart';

abstract class CategoryRepository {
  Future<List<Category>?> getAllCategories();
  Future<List<Subcategory>> getSubCategories(String categoryId);
}
