import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/entities/response/sub_category.dart';

sealed class CategoriesStates {}

class CategoriesLoadingState extends CategoriesStates {}

class CategoriesErrorState extends CategoriesStates {
  final String message;
  CategoriesErrorState({required this.message});
}

class CategoriesEmptyState extends CategoriesStates {}

class CategoriesSuccessState extends CategoriesStates {
  final List<Category> categories;
  final int selectedIndex;

  /// `null` while the selected category's subcategories are loading.
  final List<Subcategory>? subCategories;
  final String? subCategoriesError;

  CategoriesSuccessState({
    required this.categories,
    required this.selectedIndex,
    this.subCategories,
    this.subCategoriesError,
  });

  Category get selectedCategory => categories[selectedIndex];

  bool get isSubCategoriesLoading =>
      subCategories == null && subCategoriesError == null;
}
