// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;

import '../../api/data_sources/local/user_local_data_source_impl.dart' as _i94;
import '../../api/data_sources/remote/auth_remote_data_source_impl.dart'
    as _i740;
import '../../api/data_sources/remote/brands_data_source_impl.dart' as _i125;
import '../../api/data_sources/remote/cart_remote_data_source_impl.dart'
    as _i406;
import '../../api/data_sources/remote/category_remote_data_source_impl.dart'
    as _i448;
import '../../api/data_sources/remote/order_remote_data_source_impl.dart'
    as _i241;
import '../../api/data_sources/remote/product_remote_data_source_impl.dart'
    as _i895;
import '../../api/data_sources/remote/user_remote_data_source_impl.dart'
    as _i12;
import '../../api/data_sources/remote/wishlist_remote_data_source_impl.dart'
    as _i182;
import '../../api/dio/dio_module.dart' as _i67;
import '../../api/web_services.dart' as _i1069;
import '../../data/data_sources/local/user_local_data_source.dart' as _i925;
import '../../data/data_sources/remote/auth_remote_data_source.dart' as _i865;
import '../../data/data_sources/remote/brands_remote_data_source.dart' as _i292;
import '../../data/data_sources/remote/cart_remote_data_source.dart' as _i489;
import '../../data/data_sources/remote/category_remote_data_source.dart'
    as _i344;
import '../../data/data_sources/remote/order_remote_data_source.dart' as _i987;
import '../../data/data_sources/remote/product_remote_data_source.dart'
    as _i189;
import '../../data/data_sources/remote/user_remote_data_source.dart' as _i928;
import '../../data/data_sources/remote/wishlist_remote_data_source.dart'
    as _i641;
import '../../data/repos/auth_repo_impl.dart' as _i666;
import '../../data/repos/brands_repo_impl.dart' as _i780;
import '../../data/repos/cart_repo_impl.dart' as _i413;
import '../../data/repos/category_repo_impl.dart' as _i1027;
import '../../data/repos/order_repo_impl.dart' as _i1012;
import '../../data/repos/products_repo_impl.dart' as _i1037;
import '../../data/repos/user_repo_impl.dart' as _i987;
import '../../data/repos/wishlist_repo_impl.dart' as _i365;
import '../../domain/repos/auth_repo.dart' as _i595;
import '../../domain/repos/brands_repo.dart' as _i148;
import '../../domain/repos/cart_repo.dart' as _i263;
import '../../domain/repos/category_repo.dart' as _i470;
import '../../domain/repos/order_repo.dart' as _i757;
import '../../domain/repos/product_repo.dart' as _i470;
import '../../domain/repos/user_repo.dart' as _i426;
import '../../domain/repos/wishlist_repo.dart' as _i385;
import '../../domain/use_cases/add_address_use_case.dart' as _i977;
import '../../domain/use_cases/add_to_cart_use_case.dart' as _i1024;
import '../../domain/use_cases/add_to_wishlist_use_case.dart' as _i1028;
import '../../domain/use_cases/change_password_use_case.dart' as _i838;
import '../../domain/use_cases/create_cash_order_use_case.dart' as _i861;
import '../../domain/use_cases/get_addresses_use_case.dart' as _i747;
import '../../domain/use_cases/get_all_brands_use_case.dart' as _i773;
import '../../domain/use_cases/get_all_categories_use_case.dart' as _i201;
import '../../domain/use_cases/get_cached_profile_use_case.dart' as _i435;
import '../../domain/use_cases/get_cart_use_case.dart' as _i1001;
import '../../domain/use_cases/get_product_details_use_case.dart' as _i291;
import '../../domain/use_cases/get_products_use_case.dart' as _i491;
import '../../domain/use_cases/get_sub_categories_use_case.dart' as _i251;
import '../../domain/use_cases/get_wishlist_use_case.dart' as _i342;
import '../../domain/use_cases/login_use_case.dart' as _i471;
import '../../domain/use_cases/logout_use_case.dart' as _i250;
import '../../domain/use_cases/register_use_case.dart' as _i479;
import '../../domain/use_cases/remove_cart_item_use_case.dart' as _i457;
import '../../domain/use_cases/remove_from_wishlist_use_case.dart' as _i437;
import '../../domain/use_cases/update_cart_item_quantity_use_case.dart'
    as _i358;
import '../../domain/use_cases/update_profile_use_case.dart' as _i557;
import '../../features/auth/login/cubit/login_view_model.dart' as _i959;
import '../../features/auth/register/cubit/register_screen_view_model.dart'
    as _i673;
import '../../features/home_screen/cubit/home_screen_view_model.dart' as _i147;
import '../../features/tabs/cart_tab/cubit/cart_view_model.dart' as _i128;
import '../../features/tabs/category_tab/cubit/categories_view_model.dart'
    as _i824;
import '../../features/tabs/fav_tab/cubit/wishlist_view_model.dart' as _i284;
import '../../features/tabs/home_tab/cubit/home_tab_view_model.dart' as _i426;
import '../../features/tabs/product_details_tab/cubit/product_details_view_model.dart'
    as _i369;
import '../../features/tabs/product_list_tab/cubit/product_list_view_model.dart'
    as _i378;
import '../../features/tabs/profile/cubit/profile_view_model.dart' as _i921;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioModule = _$DioModule();
    gh.factory<_i147.HomeScreenViewModel>(() => _i147.HomeScreenViewModel());
    gh.singleton<_i361.BaseOptions>(() => dioModule.provideBaseOptions());
    gh.singleton<_i528.PrettyDioLogger>(
        () => dioModule.providePrettyDioLogger());
    gh.singleton<_i361.Dio>(() => dioModule.provideDio(
          gh<_i361.BaseOptions>(),
          gh<_i528.PrettyDioLogger>(),
        ));
    gh.factory<_i925.UserLocalDataSource>(() => _i94.UserLocalDataSourceImpl());
    gh.singleton<_i1069.WebServices>(
        () => dioModule.provideWebServices(gh<_i361.Dio>()));
    gh.factory<_i292.BrandsRemoteDataSource>(() =>
        _i125.BrandsRemoteDataSourceImpl(
            webServices: gh<_i1069.WebServices>()));
    gh.factory<_i987.OrderRemoteDataSource>(() =>
        _i241.OrderRemoteDataSourceImpl(webServices: gh<_i1069.WebServices>()));
    gh.factory<_i865.AuthRemoteDataSource>(() =>
        _i740.AuthRemoteDataSourceImpl(webServices: gh<_i1069.WebServices>()));
    gh.factory<_i757.OrderRepo>(() => _i1012.OrderRepoImpl(
        orderRemoteDataSource: gh<_i987.OrderRemoteDataSource>()));
    gh.factory<_i595.AuthRepository>(() => _i666.AuthRepoImpl(
          authRemoteDataSource: gh<_i865.AuthRemoteDataSource>(),
          userLocalDataSource: gh<_i925.UserLocalDataSource>(),
        ));
    gh.factory<_i148.BrandsRepo>(() => _i780.BrandsRepoImpl(
        brandsRemoteDataSource: gh<_i292.BrandsRemoteDataSource>()));
    gh.factory<_i471.LoginUseCase>(
        () => _i471.LoginUseCase(authRepository: gh<_i595.AuthRepository>()));
    gh.factory<_i479.RegisterUseCase>(() =>
        _i479.RegisterUseCase(authRepository: gh<_i595.AuthRepository>()));
    gh.factory<_i928.UserRemoteDataSource>(() =>
        _i12.UserRemoteDataSourceImpl(webServices: gh<_i1069.WebServices>()));
    gh.factory<_i344.CategoryRemoteDataSource>(
        () => _i448.CategoryRemoteDataSourceImpl(gh<_i1069.WebServices>()));
    gh.factory<_i189.ProductRemoteDataSource>(
        () => _i895.ProductRemoteDataSourceImpl(gh<_i1069.WebServices>()));
    gh.factory<_i489.CartRemoteDataSource>(() =>
        _i406.CartRemoteDataSourceImpl(webServices: gh<_i1069.WebServices>()));
    gh.factory<_i641.WishlistRemoteDataSource>(() =>
        _i182.WishlistRemoteDataSourceImpl(
            webServices: gh<_i1069.WebServices>()));
    gh.factory<_i470.CategoryRepository>(() => _i1027.CatgoryRepoImpl(
        categoryRemoteDataSource: gh<_i344.CategoryRemoteDataSource>()));
    gh.factory<_i263.CartRepo>(() => _i413.CartRepoImpl(
        cartRemoteDataSource: gh<_i489.CartRemoteDataSource>()));
    gh.factory<_i959.LoginViewModel>(
        () => _i959.LoginViewModel(loginUseCase: gh<_i471.LoginUseCase>()));
    gh.factory<_i470.ProductRepo>(() => _i1037.ProductsRepoImpl(
        productRemoteDataSource: gh<_i189.ProductRemoteDataSource>()));
    gh.factory<_i385.WishlistRepo>(() => _i365.WishlistRepoImpl(
        wishlistRemoteDataSource: gh<_i641.WishlistRemoteDataSource>()));
    gh.factory<_i861.CreateCashOrderUseCase>(
        () => _i861.CreateCashOrderUseCase(orderRepo: gh<_i757.OrderRepo>()));
    gh.factory<_i201.GetAllCategoriesUseCase>(() =>
        _i201.GetAllCategoriesUseCase(
            categoryRepository: gh<_i470.CategoryRepository>()));
    gh.factory<_i251.GetSubCategoriesUseCase>(() =>
        _i251.GetSubCategoriesUseCase(
            categoryRepository: gh<_i470.CategoryRepository>()));
    gh.factory<_i824.CategoriesViewModel>(() => _i824.CategoriesViewModel(
          getAllCategoriesUseCase: gh<_i201.GetAllCategoriesUseCase>(),
          getSubCategoriesUseCase: gh<_i251.GetSubCategoriesUseCase>(),
        ));
    gh.factory<_i773.GetAllBrandsUseCase>(
        () => _i773.GetAllBrandsUseCase(brandsRepo: gh<_i148.BrandsRepo>()));
    gh.factory<_i673.RegisterViewModel>(() =>
        _i673.RegisterViewModel(registerUseCase: gh<_i479.RegisterUseCase>()));
    gh.factory<_i426.UserRepo>(() => _i987.UserRepoImpl(
          userRemoteDataSource: gh<_i928.UserRemoteDataSource>(),
          userLocalDataSource: gh<_i925.UserLocalDataSource>(),
        ));
    gh.factory<_i1028.AddToWishlistUseCase>(() =>
        _i1028.AddToWishlistUseCase(wishlistRepo: gh<_i385.WishlistRepo>()));
    gh.factory<_i342.GetWishlistUseCase>(
        () => _i342.GetWishlistUseCase(wishlistRepo: gh<_i385.WishlistRepo>()));
    gh.factory<_i437.RemoveFromWishlistUseCase>(() =>
        _i437.RemoveFromWishlistUseCase(
            wishlistRepo: gh<_i385.WishlistRepo>()));
    gh.factory<_i1024.AddToCartUseCase>(
        () => _i1024.AddToCartUseCase(cartRepo: gh<_i263.CartRepo>()));
    gh.factory<_i1001.GetCartUseCase>(
        () => _i1001.GetCartUseCase(cartRepo: gh<_i263.CartRepo>()));
    gh.factory<_i457.RemoveCartItemUseCase>(
        () => _i457.RemoveCartItemUseCase(cartRepo: gh<_i263.CartRepo>()));
    gh.factory<_i358.UpdateCartItemQuantityUseCase>(() =>
        _i358.UpdateCartItemQuantityUseCase(cartRepo: gh<_i263.CartRepo>()));
    gh.factory<_i491.GetProductsUseCase>(
        () => _i491.GetProductsUseCase(productRepo: gh<_i470.ProductRepo>()));
    gh.factory<_i291.GetProductDetailsUseCase>(() =>
        _i291.GetProductDetailsUseCase(productRepo: gh<_i470.ProductRepo>()));
    gh.factory<_i977.AddAddressUseCase>(
        () => _i977.AddAddressUseCase(userRepo: gh<_i426.UserRepo>()));
    gh.factory<_i838.ChangePasswordUseCase>(
        () => _i838.ChangePasswordUseCase(userRepo: gh<_i426.UserRepo>()));
    gh.factory<_i747.GetAddressesUseCase>(
        () => _i747.GetAddressesUseCase(userRepo: gh<_i426.UserRepo>()));
    gh.factory<_i435.GetCachedProfileUseCase>(
        () => _i435.GetCachedProfileUseCase(userRepo: gh<_i426.UserRepo>()));
    gh.factory<_i250.LogoutUseCase>(
        () => _i250.LogoutUseCase(userRepo: gh<_i426.UserRepo>()));
    gh.factory<_i557.UpdateProfileUseCase>(
        () => _i557.UpdateProfileUseCase(userRepo: gh<_i426.UserRepo>()));
    gh.lazySingleton<_i284.WishlistViewModel>(() => _i284.WishlistViewModel(
          getWishlistUseCase: gh<_i342.GetWishlistUseCase>(),
          addToWishlistUseCase: gh<_i1028.AddToWishlistUseCase>(),
          removeFromWishlistUseCase: gh<_i437.RemoveFromWishlistUseCase>(),
        ));
    gh.factory<_i378.ProductListViewModel>(() => _i378.ProductListViewModel(
        getProductsUseCase: gh<_i491.GetProductsUseCase>()));
    gh.factory<_i921.ProfileViewModel>(() => _i921.ProfileViewModel(
          getCachedProfileUseCase: gh<_i435.GetCachedProfileUseCase>(),
          updateProfileUseCase: gh<_i557.UpdateProfileUseCase>(),
          changePasswordUseCase: gh<_i838.ChangePasswordUseCase>(),
          getAddressesUseCase: gh<_i747.GetAddressesUseCase>(),
          addAddressUseCase: gh<_i977.AddAddressUseCase>(),
          logoutUseCase: gh<_i250.LogoutUseCase>(),
        ));
    gh.lazySingleton<_i128.CartViewModel>(() => _i128.CartViewModel(
          getCartUseCase: gh<_i1001.GetCartUseCase>(),
          addToCartUseCase: gh<_i1024.AddToCartUseCase>(),
          updateCartItemQuantityUseCase:
              gh<_i358.UpdateCartItemQuantityUseCase>(),
          removeCartItemUseCase: gh<_i457.RemoveCartItemUseCase>(),
          getAddressesUseCase: gh<_i747.GetAddressesUseCase>(),
          createCashOrderUseCase: gh<_i861.CreateCashOrderUseCase>(),
        ));
    gh.factory<_i426.HomeTabViewModel>(() => _i426.HomeTabViewModel(
          getAllCategoriesUseCase: gh<_i201.GetAllCategoriesUseCase>(),
          getAllBrandsUseCase: gh<_i773.GetAllBrandsUseCase>(),
          getProductsUseCase: gh<_i491.GetProductsUseCase>(),
        ));
    gh.factory<_i369.ProductDetailsViewModel>(() =>
        _i369.ProductDetailsViewModel(
            getProductDetailsUseCase: gh<_i291.GetProductDetailsUseCase>()));
    return this;
  }
}

class _$DioModule extends _i67.DioModule {}
