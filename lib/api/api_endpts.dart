class ApiEndPts {
  static const String baseUrl = 'https://ecommerce.routemisr.com/';
  static const String loginEndPoint = 'api/v1/auth/signin';
  static const String registerEndPoint = 'api/v1/auth/signup';
  static const String getAllCategoriesEndPoint = 'api/v1/categories';
  static const String subCategoriesOnCategoryEndPoint =
      'api/v1/categories/{id}/subcategories';
  static const String getAllBrandsEndPoint = 'api/v1/brands';
  static const String getProductsEndPoint = 'api/v1/products';
  static const String productDetailsEndPoint = 'api/v1/products/{id}';
  static const String cartEndPoint = 'api/v1/cart';
  static const String cartItemEndPoint = 'api/v1/cart/{id}';
  static const String wishlistEndPoint = 'api/v1/wishlist';
  static const String wishlistItemEndPoint = 'api/v1/wishlist/{id}';
  static const String updateMeEndPoint = 'api/v1/users/updateMe/';
  static const String changePasswordEndPoint = 'api/v1/users/changeMyPassword';
  static const String addressesEndPoint = 'api/v1/addresses';
  static const String cashOrderEndPoint = 'api/v1/orders/{cartId}';
}
