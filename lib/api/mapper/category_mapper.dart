import 'package:ecommerce/api/model/response/category/data_dto.dart';
import 'package:ecommerce/domain/entities/response/category.dart';

extension CategoryMapper on CategoryDataDto {
  Category toCategory() {
    return Category(name: name, image: image, id: id, slug: slug);
  }
}
