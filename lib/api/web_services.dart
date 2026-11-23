import 'package:dio/dio.dart';
import 'package:ecommerce/api/dio/auth_interceptor.dart';
import 'package:ecommerce/api/model/request/address_request_dto.dart';
import 'package:ecommerce/api/model/request/cart_quantity_request_dto.dart';
import 'package:ecommerce/api/model/request/change_password_request_dto.dart';
import 'package:ecommerce/api/model/request/product_request_dto.dart';
import 'package:ecommerce/api/model/request/register_request.dart';
import 'package:ecommerce/api/model/request/shipping_address_request_dto.dart';
import 'package:ecommerce/api/model/request/update_me_request_dto.dart';
import 'package:ecommerce/api/model/response/address/address_response_dto.dart';
import 'package:ecommerce/api/model/response/auth_response.dart';
import 'package:ecommerce/api/model/response/brands/brands_response_dto.dart';
import 'package:ecommerce/api/model/response/cart/cart_response_dto.dart';
import 'package:ecommerce/api/model/response/common/category_response_dto.dart';
import 'package:ecommerce/api/model/response/product/product_details_response_dto.dart';
import 'package:ecommerce/api/model/response/product/product_response_dto.dart';
import 'package:ecommerce/api/model/response/product/sub_category_response_dto.dart';
import 'package:ecommerce/api/model/response/wishlist/wishlist_response_dto.dart';
import 'package:retrofit/retrofit.dart';

import 'api_endpts.dart';
import 'model/request/login_request.dart';

part 'web_services.g.dart';

@RestApi()
abstract class WebServices {
  factory WebServices(Dio dio, {String? baseUrl}) = _WebServices;

  @POST(ApiEndPts.loginEndPoint)
  Future<AuthResponse> logIn(@Body() LoginRequest loginRequest);

  @POST(ApiEndPts.registerEndPoint)
  Future<AuthResponse> register(@Body() RegisterRequest registerRequest);

  @GET(ApiEndPts.getAllCategoriesEndPoint)
  Future<CategoryResponseDto> getAllCategories();

  @GET(ApiEndPts.subCategoriesOnCategoryEndPoint)
  Future<SubCategoryResponseDto> getSubCategoriesOnCategory(
    @Path('id') String categoryId,
  );

  @GET(ApiEndPts.getAllBrandsEndPoint)
  Future<BrandsResponseDto> getAllBrands();

  @GET(ApiEndPts.getProductsEndPoint)
  Future<ProductResponseDto> getAllProducts(
    @Queries() Map<String, dynamic> queries,
  );

  @GET(ApiEndPts.productDetailsEndPoint)
  Future<ProductDetailsResponseDto> getProductById(@Path('id') String id);

  @GET(ApiEndPts.cartEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<CartResponseDto> getCart();

  @POST(ApiEndPts.cartEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<CartResponseDto> addToCart(@Body() ProductRequestDto request);

  @PUT(ApiEndPts.cartItemEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<CartResponseDto> updateCartItemQuantity(
    @Path('id') String productId,
    @Body() CartQuantityRequestDto request,
  );

  @DELETE(ApiEndPts.cartItemEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<CartResponseDto> removeCartItem(@Path('id') String productId);

  @GET(ApiEndPts.wishlistEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<WishlistResponseDto> getWishlist();

  @POST(ApiEndPts.wishlistEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<WishlistResponseDto> addToWishlist(@Body() ProductRequestDto request);

  @DELETE(ApiEndPts.wishlistItemEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<WishlistResponseDto> removeFromWishlist(@Path('id') String productId);

  @PUT(ApiEndPts.updateMeEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<AuthResponse> updateMe(@Body() UpdateMeRequestDto request);

  @PUT(ApiEndPts.changePasswordEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<AuthResponse> changePassword(@Body() ChangePasswordRequestDto request);

  @GET(ApiEndPts.addressesEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<AddressResponseDto> getAddresses();

  @POST(ApiEndPts.addressesEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<AddressResponseDto> addAddress(@Body() AddressRequestDto request);

  @POST(ApiEndPts.cashOrderEndPoint)
  @Extra({AuthInterceptor.authTypeKey: AuthInterceptor.tokenAuth})
  Future<void> createCashOrder(
    @Path('cartId') String cartId,
    @Body() ShippingAddressRequestDto request,
  );
}
