import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/core/utils/cache.dart';
import 'package:ecommerce/core/utils/toast_utils.dart';
import 'package:ecommerce/features/auth/register/register_screen.dart';
import 'package:ecommerce/features/home_screen/home_screen.dart';
import 'package:ecommerce/features/tabs/cart_tab/cart_tab.dart';
import 'package:ecommerce/features/tabs/cart_tab/cubit/cart_states.dart';
import 'package:ecommerce/features/tabs/cart_tab/cubit/cart_view_model.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_states.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_view_model.dart';
import 'package:ecommerce/features/tabs/product_details_tab/product_details_tab.dart';
import 'package:ecommerce/features/tabs/product_list_tab/product_list_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/di/di.dart';
import 'core/utils/app_theme.dart';
import 'features/auth/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesUtils.getInstance();
  configureDependencies();
  String routeName;
  if (SharedPreferencesUtils.readData(key: CacheKeys.token) != null) {
    routeName = AppRoutes.homeScreen;
  } else {
    routeName = AppRoutes.loginScreen;
  }
  runApp(MyApp(route: routeName));
}

class MyApp extends StatelessWidget {
  final String route;
  const MyApp({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // App-wide view models shared by every screen that shows products.
      providers: [
        BlocProvider<CartViewModel>.value(value: getIt<CartViewModel>()),
        BlocProvider<WishlistViewModel>.value(
          value: getIt<WishlistViewModel>(),
        ),
      ],
      child: ScreenUtilInit(
        // Recomputed whenever the window changes (fold/unfold, rotation,
        // split-screen) so scale factors stay within AppLayout's clamp.
        designSize: AppLayout.designSizeFor(MediaQuery.sizeOf(context)),
        minTextAdapt: true,
        // The clamp already protects short windows; splitScreenMode would
        // substitute a 700dp height and over-scale landscape layouts.
        splitScreenMode: false,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: route,
            routes: {
              AppRoutes.loginScreen: (context) => LoginScreen(),
              AppRoutes.registerScreen: (context) => const RegisterScreen(),
              AppRoutes.homeScreen: (context) => const HomeScreen(),
              AppRoutes.productList: (context) => const ProductListTab(),
              AppRoutes.productDetails: (context) => const ProductDetailsTab(),
              AppRoutes.cartTab: (context) => const CartTab(),
            },
            theme: AppTheme.lightMode,
            themeMode: ThemeMode.light,
            builder: (context, child) =>
                _ActionFeedbackListener(child: child ?? const SizedBox()),
          );
        },
      ),
    );
  }
}

/// Shows toasts for cart/wishlist actions triggered from any screen.
class _ActionFeedbackListener extends StatelessWidget {
  final Widget child;
  const _ActionFeedbackListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CartViewModel, CartStates>(
          listenWhen: (_, current) => current is CartActionState,
          listener: (_, state) => _toast(
            (state as CartActionState).message,
            isError: state is CartActionErrorState,
          ),
        ),
        BlocListener<WishlistViewModel, WishlistStates>(
          listenWhen: (_, current) => current is WishlistActionState,
          listener: (_, state) => _toast(
            (state as WishlistActionState).message,
            isError: state is WishlistActionErrorState,
          ),
        ),
      ],
      child: child,
    );
  }

  void _toast(String message, {required bool isError}) {
    ToastUtils.toast(
      msg: message,
      bgColor: isError ? AppColors.redColor : AppColors.primaryColor,
      txtColor: AppColors.whiteColor,
    );
  }
}
