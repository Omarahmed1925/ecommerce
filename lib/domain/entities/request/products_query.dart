class ProductsQuery {
  final String? categoryId;
  final String? subcategoryId;
  final String? brandId;
  final String? keyword;
  final String? sort;
  final int page;
  final int limit;

  ProductsQuery({
    this.categoryId,
    this.subcategoryId,
    this.brandId,
    this.keyword,
    this.sort,
    this.page = 1,
    this.limit = 20,
  });

  ProductsQuery copyWith({int? page, String? sort}) {
    return ProductsQuery(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      brandId: brandId,
      keyword: keyword,
      sort: sort ?? this.sort,
      page: page ?? this.page,
      limit: limit,
    );
  }
}
