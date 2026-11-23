import 'package:ecommerce/api/data_sources/remote/product_remote_data_source_impl.dart';
import 'package:ecommerce/api/model/response/common/metadata_dto.dart';
import 'package:ecommerce/api/model/response/product/product_dto.dart';
import 'package:ecommerce/api/model/response/product/product_response_dto.dart';
import 'package:ecommerce/api/web_services.dart';
import 'package:ecommerce/domain/entities/request/products_query.dart';
import 'package:flutter_test/flutter_test.dart';

/// Serves a 2-page catalog and records the queries it receives.
class FakeWebServices extends Fake implements WebServices {
  final requests = <Map<String, dynamic>>[];

  @override
  Future<ProductResponseDto> getAllProducts(
    Map<String, dynamic> queries,
  ) async {
    requests.add(queries);
    final page = queries['page'] as int;
    final titles = page == 1
        ? ['Logo T-Shirt Green', 'Woman Shawl']
        : ["Slim Fit Men's Shirt", 'Canon Camera'];
    return ProductResponseDto(
      metadata: MetadataDto(currentPage: page, numberOfPages: 2),
      data: [for (final t in titles) ProductDto(id: t, title: t)],
    );
  }
}

void main() {
  test('keyword search pages the catalog and matches titles locally', () async {
    final web = FakeWebServices();
    final page = await ProductRemoteDataSourceImpl(
      web,
    ).getProducts(ProductsQuery(keyword: '  SHIRT ', categoryId: 'c'));

    expect(page.products.map((p) => p.title), [
      'Logo T-Shirt Green',
      "Slim Fit Men's Shirt",
    ]);
    expect(page.hasMore, isFalse);
    // Both catalog pages fetched; the broken keyword param is never sent,
    // other filters are kept.
    expect(web.requests.map((q) => q['page']), [1, 2]);
    expect(web.requests.every((q) => !q.containsKey('keyword')), isTrue);
    expect(web.requests.every((q) => q['category[in]'] == 'c'), isTrue);
  });

  test('without a keyword the request is passed through unchanged', () async {
    final web = FakeWebServices();
    await ProductRemoteDataSourceImpl(
      web,
    ).getProducts(ProductsQuery(page: 2, limit: 20));
    expect(web.requests.single, {'page': 2, 'limit': 20});
  });
}
