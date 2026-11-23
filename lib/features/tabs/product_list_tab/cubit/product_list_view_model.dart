import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/domain/entities/request/products_query.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/domain/use_cases/get_products_use_case.dart';
import 'package:ecommerce/features/tabs/product_list_tab/cubit/product_list_states.dart';
import 'package:ecommerce/features/tabs/product_list_tab/product_list_args.dart';
import 'package:injectable/injectable.dart';

/// Sort values accepted by the products endpoint (`sort` query param).
enum ProductSort {
  none(null, 'Default'),
  priceLowToHigh('price', 'Price: low to high'),
  priceHighToLow('-price', 'Price: high to low'),
  bestSelling('-sold', 'Best selling'),
  topRated('-ratingsAverage', 'Top rated');

  final String? apiValue;
  final String label;
  const ProductSort(this.apiValue, this.label);

  static ProductSort fromApiValue(String? value) =>
      values.firstWhere((s) => s.apiValue == value, orElse: () => none);
}

@injectable
class ProductListViewModel extends Cubit<ProductListStates> {
  final GetProductsUseCase getProductsUseCase;

  ProductListViewModel({required this.getProductsUseCase})
    : super(ProductListLoadingState());

  late ProductsQuery _query;
  final List<Product> _products = [];
  bool _hasMore = false;
  bool _isLoadingMore = false;
  String? _loadMoreError;

  ProductSort get sort => ProductSort.fromApiValue(_query.sort);

  void init(ProductListArgs args) {
    _query = ProductsQuery(
      categoryId: args.categoryId,
      subcategoryId: args.subcategoryId,
      brandId: args.brandId,
      keyword: args.keyword,
      sort: args.sort,
    );
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    emit(ProductListLoadingState());
    _query = _query.copyWith(page: 1);
    _loadMoreError = null;
    try {
      final page = await getProductsUseCase.invoke(_query);
      _products
        ..clear()
        ..addAll(page.products);
      _hasMore = page.hasMore;
      _emitList();
    } on AppExceptions catch (e) {
      emit(ProductListErrorState(message: e.message));
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore || state is! ProductListSuccessState) {
      return;
    }
    _isLoadingMore = true;
    _loadMoreError = null;
    _emitList();
    try {
      final nextQuery = _query.copyWith(page: _query.page + 1);
      final page = await getProductsUseCase.invoke(nextQuery);
      _query = nextQuery;
      _products.addAll(page.products);
      _hasMore = page.hasMore;
    } on AppExceptions catch (e) {
      _loadMoreError = e.message;
    }
    _isLoadingMore = false;
    _emitList();
  }

  void changeSort(ProductSort sort) {
    if (sort == this.sort) return;
    _query = ProductsQuery(
      categoryId: _query.categoryId,
      subcategoryId: _query.subcategoryId,
      brandId: _query.brandId,
      keyword: _query.keyword,
      sort: sort.apiValue,
      limit: _query.limit,
    );
    loadFirstPage();
  }

  void _emitList() {
    if (_products.isEmpty) {
      emit(ProductListEmptyState());
    } else {
      emit(
        ProductListSuccessState(
          products: List.unmodifiable(_products),
          hasMore: _hasMore,
          isLoadingMore: _isLoadingMore,
          loadMoreError: _loadMoreError,
        ),
      );
    }
  }
}
