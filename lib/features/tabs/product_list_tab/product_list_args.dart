/// Route arguments for [AppRoutes.productList]; all filters are optional.
class ProductListArgs {
  final String title;
  final String? categoryId;
  final String? subcategoryId;
  final String? brandId;
  final String? keyword;
  final String? sort;

  const ProductListArgs({
    required this.title,
    this.categoryId,
    this.subcategoryId,
    this.brandId,
    this.keyword,
    this.sort,
  });
}
