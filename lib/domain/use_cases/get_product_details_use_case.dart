import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/domain/repos/product_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductDetailsUseCase {
  final ProductRepo productRepo;

  GetProductDetailsUseCase({required this.productRepo});

  Future<Product> invoke(String id) => productRepo.getProductById(id);
}
