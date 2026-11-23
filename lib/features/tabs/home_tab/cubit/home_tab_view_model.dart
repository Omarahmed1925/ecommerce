import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/domain/entities/request/products_query.dart';
import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/entities/response/products_page.dart';
import 'package:ecommerce/domain/use_cases/get_all_brands_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_all_categories_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_products_use_case.dart';
import 'package:ecommerce/features/tabs/home_tab/cubit/home_tab_states.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeTabViewModel extends Cubit<HomeTabState> {
  static const String bestSellersSort = '-sold';

  final GetAllCategoriesUseCase getAllCategoriesUseCase;
  final GetAllBrandsUseCase getAllBrandsUseCase;
  final GetProductsUseCase getProductsUseCase;

  HomeTabViewModel({
    required this.getAllCategoriesUseCase,
    required this.getAllBrandsUseCase,
    required this.getProductsUseCase,
  }) : super(HomeTabInitial());

  Future<void> loadHome() async {
    emit(HomeTabLoading());
    try {
      // Future.wait reports the first failure and discards the others.
      final results = await Future.wait<Object?>([
        getAllCategoriesUseCase.invoke(),
        getAllBrandsUseCase.invoke(),
        getProductsUseCase.invoke(
          ProductsQuery(sort: bestSellersSort, limit: 10),
        ),
      ]);
      emit(
        HomeTabSuccess(
          categories: results[0] as List<Category>? ?? [],
          brands: results[1] as List<Category>? ?? [],
          bestSellers: (results[2] as ProductsPage).products,
        ),
      );
    } on AppExceptions catch (e) {
      emit(HomeTabFailure(errorMessage: e.message));
    }
  }
}
