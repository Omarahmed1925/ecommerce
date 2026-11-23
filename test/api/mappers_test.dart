import 'package:ecommerce/api/mapper/cart_mapper.dart';
import 'package:ecommerce/api/mapper/products_page_mapper.dart';
import 'package:ecommerce/api/model/response/cart/cart_response_dto.dart';
import 'package:ecommerce/api/model/response/product/product_response_dto.dart';
import 'package:ecommerce/api/model/response/wishlist/wishlist_response_dto.dart';
import 'package:ecommerce/domain/entities/request/products_query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartResponseDto', () {
    test('maps a populated product (GET cart)', () {
      final cart = CartResponseDto.fromJson({
        'status': 'success',
        'numOfCartItems': 1,
        'cartId': 'cart1',
        'data': {
          '_id': 'cart1',
          'totalCartPrice': 300,
          'products': [
            {
              'count': 2,
              '_id': 'line1',
              'price': 150,
              'product': {'_id': 'p1', 'title': 'Shoe', 'imageCover': 'x'},
            },
          ],
        },
      }).toCart();

      expect(cart.cartId, 'cart1');
      expect(cart.totalCartPrice, 300);
      expect(cart.items.single.count, 2);
      expect(cart.items.single.product?.id, 'p1');
      expect(cart.items.single.product?.title, 'Shoe');
    });

    test('maps a bare product id (add to cart)', () {
      final cart = CartResponseDto.fromJson({
        'cartId': 'cart1',
        'data': {
          'products': [
            {'count': 1, 'price': 10, 'product': 'p1'},
          ],
        },
      }).toCart();

      expect(cart.items.single.product?.id, 'p1');
      expect(cart.items.single.product?.title, isNull);
    });
  });

  test('WishlistResponseDto accepts ids or products', () {
    final ids = WishlistResponseDto.fromJson({
      'data': ['a', 'b'],
    });
    final products = WishlistResponseDto.fromJson({
      'data': [
        {'_id': 'a', 'title': 'A'},
      ],
    });

    expect(ids.data?.map((p) => p.id), ['a', 'b']);
    expect(products.data?.single.title, 'A');
  });

  test('ProductsQuery uses the Postman query keys', () {
    final map = ProductsQuery(
      categoryId: 'c',
      subcategoryId: 's',
      brandId: 'b',
      keyword: 'shoe',
      sort: '-price',
      page: 2,
      limit: 20,
    ).toQueryMap();

    expect(map, {
      'page': 2,
      'limit': 20,
      'sort': '-price',
      'keyword': 'shoe',
      'brand': 'b',
      'category[in]': 'c',
      'subcategory': 's',
    });
    expect(ProductsQuery().toQueryMap().keys, ['page', 'limit']);
  });

  test('ProductResponseDto maps pagination and discount', () {
    final page = ProductResponseDto.fromJson({
      'metadata': {'currentPage': 1, 'numberOfPages': 3},
      'data': [
        {'_id': 'p', 'price': 200, 'priceAfterDiscount': 150},
      ],
    }).toProductsPage();

    expect(page.hasMore, isTrue);
    expect(page.products.single.finalPrice, 150);
    expect(page.products.single.hasDiscount, isTrue);
  });
}
