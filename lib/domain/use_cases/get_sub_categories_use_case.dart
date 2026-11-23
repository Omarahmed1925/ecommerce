import 'package:ecommerce/domain/entities/response/sub_category.dart';
import 'package:ecommerce/domain/repos/category_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSubCategoriesUseCase {
  final CategoryRepository categoryRepository;

  GetSubCategoriesUseCase({required this.categoryRepository});

  Future<List<Subcategory>> invoke(String categoryId) =>
      categoryRepository.getSubCategories(categoryId);
}
