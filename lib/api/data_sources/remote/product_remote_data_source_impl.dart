import 'package:dio/dio.dart';
import 'package:ecommerce/api/mapper/product_mapper.dart';
import 'package:ecommerce/api/mapper/products_page_mapper.dart';
import 'package:ecommerce/api/web_services.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/core/exceptions/dio_exception_mapper.dart';
import 'package:ecommerce/domain/entities/request/products_query.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/domain/entities/response/products_page.dart';
import 'package:injectable/injectable.dart';

import '../../../data/data_sources/remote/product_remote_data_source.dart';

@Injectable(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final WebServices webServices;
  ProductRemoteDataSourceImpl(this.webServices);

  /// Largest page the products endpoint returns.
  static const int _serverMaxPageSize = 50;

  /// Safety cap for [_searchByTitle] on a very large catalog.
  static const int _maxSearchPages = 10;

  @override
  Future<ProductsPage> getProducts(ProductsQuery query) async {
    try {
      final keyword = query.keyword?.trim().toLowerCase();
      if (keyword != null && keyword.isNotEmpty) {
        return await _searchByTitle(query, keyword);
      }
      final response = await webServices.getAllProducts(query.toQueryMap());
      return response.toProductsPage();
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  /// The backend ignores `keyword` (every search returns 0 results, even an
  /// exact title word), so page through the catalog with the remaining
  /// filters and match titles here. Results come back as a single page.
  Future<ProductsPage> _searchByTitle(
    ProductsQuery query,
    String keyword,
  ) async {
    final matches = <Product>[];
    var page = 1;
    var numberOfPages = 1;
    do {
      final response = await webServices.getAllProducts(
        ProductsQuery(
          categoryId: query.categoryId,
          subcategoryId: query.subcategoryId,
          brandId: query.brandId,
          sort: query.sort,
          page: page,
          limit: _serverMaxPageSize,
        ).toQueryMap(),
      );
      final result = response.toProductsPage();
      matches.addAll(
        result.products.where(
          (p) => (p.title ?? '').toLowerCase().contains(keyword),
        ),
      );
      numberOfPages = result.numberOfPages;
      page++;
    } while (page <= numberOfPages && page <= _maxSearchPages);
    return ProductsPage(products: matches, currentPage: 1, numberOfPages: 1);
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await webServices.getProductById(id);
      final product = response.data;
      if (product == null) {
        throw ServerException(message: 'Product not found');
      }
      return product.toProduct();
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}
