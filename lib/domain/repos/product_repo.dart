import 'package:ecommerce/domain/entities/request/products_query.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/domain/entities/response/products_page.dart';

abstract class ProductRepo {
  Future<ProductsPage> getProducts(ProductsQuery query);
  Future<Product> getProductById(String id);
}
