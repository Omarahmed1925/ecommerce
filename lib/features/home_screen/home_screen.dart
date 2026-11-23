import 'package:ecommerce/config/di/di.dart';
import 'package:ecommerce/core/utils/app_assets.dart';
import 'package:ecommerce/features/home_screen/cubit/home_screen_view_model.dart';
import 'package:ecommerce/features/home_screen/cubit/home_states.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_view_model.dart';
import 'package:ecommerce/widgets/adaptive_navigation_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _destinations = [
    AdaptiveDestination(
      label: 'Home',
      selectedIcon: AppAssets.selectedHome,
      unselectedIcon: AppAssets.unselectedHome,
    ),
    AdaptiveDestination(
      label: 'Categories',
      selectedIcon: AppAssets.selectedCategories,
      unselectedIcon: AppAssets.unselectedCategories,
    ),
    AdaptiveDestination(
      label: 'Wishlist',
      selectedIcon: AppAssets.selectedFavs,
      unselectedIcon: AppAssets.unselectedFavs,
    ),
    AdaptiveDestination(
      label: 'Account',
      selectedIcon: AppAssets.selectedProfile,
      unselectedIcon: AppAssets.unselectedProfile,
    ),
  ];

  final HomeScreenViewModel viewModel = getIt<HomeScreenViewModel>();

  @override
  void initState() {
    super.initState();
    // Populates wishlist hearts across all tabs and the Wishlist tab itself.
    context.read<WishlistViewModel>().getWishlist();
  }

  @override
  void dispose() {
    viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: BlocBuilder<HomeScreenViewModel, HomeStates>(
        bloc: viewModel,
        builder: (context, state) {
          return AdaptiveNavigationShell(
            selectedIndex: viewModel.currentIndex,
            onDestinationSelected: viewModel.changeIndex,
            destinations: _destinations,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              // IndexedStack keeps each tab's state/scroll when switching
              // and across fold/unfold.
              child: IndexedStack(
                index: viewModel.currentIndex,
                children: viewModel.pages,
              ),
            ),
          );
        },
      ),
    );
  }
}
