import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/repos/category_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllCategoriesUseCase {
  CategoryRepository categoryRepository;
  GetAllCategoriesUseCase({required this.categoryRepository});
  Future<List<Category>?> invoke() async {
    return await categoryRepository.getAllCategories();
  }
}
