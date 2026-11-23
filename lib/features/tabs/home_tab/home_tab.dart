import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:ecommerce/widgets/responsive_center.dart';
import 'package:ecommerce/config/di/di.dart';
import 'package:ecommerce/core/utils/app_assets.dart';
import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/features/home_screen/cubit/home_screen_view_model.dart';
import 'package:ecommerce/features/tabs/home_tab/cubit/home_tab_states.dart';
import 'package:ecommerce/features/tabs/home_tab/cubit/home_tab_view_model.dart';
import 'package:ecommerce/features/tabs/home_tab/widgets/category_section.dart';
import 'package:ecommerce/features/tabs/home_tab/widgets/image_item.dart';
import 'package:ecommerce/features/tabs/home_tab/widgets/line_break.dart';
import 'package:ecommerce/features/tabs/product_list_tab/product_list_args.dart';
import 'package:ecommerce/widgets/custom_search_row.dart';
import 'package:ecommerce/widgets/main_error.dart';
import 'package:ecommerce/widgets/main_loading.dart';
import 'package:ecommerce/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController searchController = TextEditingController();
  final HomeTabViewModel homeTabViewModel = getIt<HomeTabViewModel>();

  @override
  void initState() {
    super.initState();
    homeTabViewModel.loadHome();
  }

  @override
  void dispose() {
    searchController.dispose();
    homeTabViewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Image.asset(AppAssets.routeSmallLogo),
      ),
      body: ResponsiveCenter(
        maxWidth: AppLayout.contentMaxWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSearchRow(searchController: searchController),
              SizedBox(height: 18.h),
              const ImageItem(),
              SizedBox(height: 24.h),
              BlocBuilder<HomeTabViewModel, HomeTabState>(
                bloc: homeTabViewModel,
                builder: (context, state) => switch (state) {
                  HomeTabFailure() => MainError(
                    eMessage: state.errorMessage,
                    onPress: homeTabViewModel.loadHome,
                  ),
                  HomeTabSuccess() => _buildSections(state),
                  _ => const MainLoading(),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSections(HomeTabSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LineBreak(
          text: 'Categories',
          onViewAll: () => context.read<HomeScreenViewModel>().changeIndex(
            HomeScreenViewModel.categoriesTabIndex,
          ),
        ),
        SizedBox(height: 8.h),
        CategorySection(
          categories: state.categories,
          onCategoryTap: (category) => _openProducts(
            ProductListArgs(
              title: category.name ?? 'Products',
              categoryId: category.id,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        LineBreak(
          text: 'Best Sellers',
          onViewAll: () => _openProducts(
            const ProductListArgs(
              title: 'Best Sellers',
              sort: HomeTabViewModel.bestSellersSort,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _buildBestSellers(state.bestSellers),
        SizedBox(height: 16.h),
        LineBreak(text: 'Brands'),
        SizedBox(height: 8.h),
        CategorySection(
          categories: state.brands,
          onCategoryTap: (brand) => _openProducts(
            ProductListArgs(title: brand.name ?? 'Products', brandId: brand.id),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildBestSellers(List<Product> products) {
    return SizedBox(
      height: 260.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, index) => SizedBox(
          width: 191.w,
          child: ProductCard(product: products[index]),
        ),
      ),
    );
  }

  void _openProducts(ProductListArgs args) {
    Navigator.pushNamed(context, AppRoutes.productList, arguments: args);
  }
}
