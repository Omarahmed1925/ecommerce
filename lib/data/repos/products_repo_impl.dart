import 'package:ecommerce/data/data_sources/remote/product_remote_data_source.dart';
import 'package:ecommerce/domain/entities/request/products_query.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/domain/entities/response/products_page.dart';
import 'package:ecommerce/domain/repos/product_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductRepo)
class ProductsRepoImpl implements ProductRepo {
  final ProductRemoteDataSource productRemoteDataSource;

  ProductsRepoImpl({required this.productRemoteDataSource});

  @override
  Future<ProductsPage> getProducts(ProductsQuery query) =>
      productRemoteDataSource.getProducts(query);

  @override
  Future<Product> getProductById(String id) =>
      productRemoteDataSource.getProductById(id);
}
