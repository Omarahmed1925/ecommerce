import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/entities/response/sub_category.dart';
import 'package:ecommerce/domain/use_cases/get_all_categories_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_sub_categories_use_case.dart';
import 'package:ecommerce/features/tabs/category_tab/cubit/categories_states.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoriesViewModel extends Cubit<CategoriesStates> {
  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final GetSubCategoriesUseCase getSubCategoriesUseCase;

  CategoriesViewModel({
    required this.getAllCategoriesUseCase,
    required this.getSubCategoriesUseCase,
  }) : super(CategoriesLoadingState());

  List<Category> _categories = [];
  int _selectedIndex = 0;

  Future<void> loadCategories() async {
    emit(CategoriesLoadingState());
    try {
      _categories = await getAllCategoriesUseCase.invoke() ?? [];
      if (_categories.isEmpty) {
        emit(CategoriesEmptyState());
        return;
      }
      await selectCategory(0);
    } on AppExceptions catch (e) {
      emit(CategoriesErrorState(message: e.message));
    }
  }

  Future<void> selectCategory(int index) async {
    if (index < 0 || index >= _categories.length) return;
    _selectedIndex = index;
    emit(CategoriesSuccessState(categories: _categories, selectedIndex: index));
    final categoryId = _categories[index].id;
    if (categoryId == null) {
      emit(_withSubCategories(index, subCategories: const []));
      return;
    }
    try {
      final subCategories = await getSubCategoriesUseCase.invoke(categoryId);
      // Ignore late responses if the user already picked another category.
      if (_selectedIndex != index) return;
      emit(_withSubCategories(index, subCategories: subCategories));
    } on AppExceptions catch (e) {
      if (_selectedIndex != index) return;
      emit(_withSubCategories(index, error: e.message));
    }
  }

  Future<void> retrySubCategories() => selectCategory(_selectedIndex);

  CategoriesSuccessState _withSubCategories(
    int index, {
    List<Subcategory>? subCategories,
    String? error,
  }) {
    return CategoriesSuccessState(
      categories: _categories,
      selectedIndex: index,
      subCategories: subCategories,
      subCategoriesError: error,
    );
  }
}
