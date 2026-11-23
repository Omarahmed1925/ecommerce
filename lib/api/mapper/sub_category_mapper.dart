import 'package:ecommerce/api/model/response/product/sub_category_dto.dart';
import 'package:ecommerce/domain/entities/response/sub_category.dart';

extension SubCategoryMapper on SubcategoryDto {
  Subcategory toSubCategory() {
    return Subcategory(id: id, name: name, slug: slug, category: category);
  }
}
