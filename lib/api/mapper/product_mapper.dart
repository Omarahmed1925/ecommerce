import 'package:ecommerce/api/mapper/category_mapper.dart';
import 'package:ecommerce/api/mapper/sub_category_mapper.dart';
import 'package:ecommerce/api/model/response/product/product_dto.dart';
import 'package:ecommerce/domain/entities/response/product.dart';

extension ProductMapper on ProductDto {
  Product toProduct() {
    return Product(
      slug: slug,
      description: description,
      id: id,
      price: price,
      priceAfterDiscount: priceAfterDiscount,
      title: title,
      images: images,
      imageCover: imageCover,
      createdAt: createdAt,
      quantity: quantity,
      ratingsAverage: ratingsAverage,
      ratingsQuantity: ratingsQuantity,
      sold: sold,
      subcategory:
          subcategory
              ?.map((subCategoryDto) => subCategoryDto.toSubCategory())
              .toList() ??
          [],
      updatedAt: updatedAt,
      brand: brand?.toCategory(),
      category: category?.toCategory(),
    );
  }
}
