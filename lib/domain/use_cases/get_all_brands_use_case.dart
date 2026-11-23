import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/repos/brands_repo.dart';
import 'package:ecommerce/domain/repos/category_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllBrandsUseCase {
  BrandsRepo brandsRepo;
  GetAllBrandsUseCase({required this.brandsRepo});
  Future<List<Category>?> invoke() async {
    return await brandsRepo.getAllBrands();
  }
}
