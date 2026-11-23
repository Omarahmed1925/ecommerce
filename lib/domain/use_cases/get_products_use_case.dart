import 'package:ecommerce/domain/entities/request/products_query.dart';
import 'package:ecommerce/domain/entities/response/products_page.dart';
import 'package:ecommerce/domain/repos/product_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsUseCase {
  final ProductRepo productRepo;

  GetProductsUseCase({required this.productRepo});

  Future<ProductsPage> invoke(ProductsQuery query) =>
      productRepo.getProducts(query);
}
