import 'package:ecommerce/api/mapper/product_mapper.dart';
import 'package:ecommerce/api/model/response/product/product_response_dto.dart';
import 'package:ecommerce/domain/entities/request/products_query.dart';
import 'package:ecommerce/domain/entities/response/products_page.dart';

extension ProductsPageMapper on ProductResponseDto {
  ProductsPage toProductsPage() {
    return ProductsPage(
      products: data?.map((dto) => dto.toProduct()).toList() ?? [],
      currentPage: metadata?.currentPage ?? 1,
      numberOfPages: metadata?.numberOfPages ?? 1,
    );
  }
}

extension ProductsQueryMapper on ProductsQuery {
  /// Query keys as defined in the Postman "Get All Products" request.
  Map<String, dynamic> toQueryMap() {
    return {
      'page': page,
      'limit': limit,
      if (sort != null) 'sort': sort,
      if (keyword != null && keyword!.isNotEmpty) 'keyword': keyword,
      if (brandId != null) 'brand': brandId,
      if (categoryId != null) 'category[in]': categoryId,
      if (subcategoryId != null) 'subcategory': subcategoryId,
    };
  }
}
