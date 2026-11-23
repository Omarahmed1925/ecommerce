import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:ecommerce/widgets/responsive_center.dart';
import 'package:ecommerce/config/di/di.dart';
import 'package:ecommerce/core/utils/app_assets.dart';
import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/features/tabs/category_tab/cubit/categories_states.dart';
import 'package:ecommerce/features/tabs/category_tab/cubit/categories_view_model.dart';
import 'package:ecommerce/features/tabs/category_tab/widgets/category_side_item.dart';
import 'package:ecommerce/features/tabs/category_tab/widgets/sub_category_item.dart';
import 'package:ecommerce/features/tabs/product_list_tab/product_list_args.dart';
import 'package:ecommerce/widgets/app_network_image.dart';
import 'package:ecommerce/widgets/custom_search_row.dart';
import 'package:ecommerce/widgets/main_empty.dart';
import 'package:ecommerce/widgets/main_error.dart';
import 'package:ecommerce/widgets/main_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  final CategoriesViewModel viewModel = getIt<CategoriesViewModel>();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.loadCategories();
  }

  @override
  void dispose() {
    searchController.dispose();
    viewModel.close();
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
        child: Column(
          children: [
            CustomSearchRow(searchController: searchController),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<CategoriesViewModel, CategoriesStates>(
                bloc: viewModel,
                builder: (context, state) => switch (state) {
                  CategoriesErrorState() => MainError(
                    eMessage: state.message,
                    onPress: viewModel.loadCategories,
                  ),
                  CategoriesEmptyState() => const MainEmpty(
                    message: 'No categories available',
                  ),
                  CategoriesSuccessState() => _buildContent(state),
                  CategoriesLoadingState() => const MainLoading(),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(CategoriesSuccessState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 137.w,
          decoration: BoxDecoration(
            color: AppColors.sidebarColor,
            border: Border.all(color: AppColors.primary300pacity, width: 2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              bottomLeft: Radius.circular(12.r),
            ),
          ),
          child: ListView.builder(
            itemCount: state.categories.length,
            itemBuilder: (context, index) => CategorySideItem(
              category: state.categories[index],
              isSelected: index == state.selectedIndex,
              onTap: () => viewModel.selectCategory(index),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(child: _buildSelectedCategory(state)),
      ],
    );
  }

  Widget _buildSelectedCategory(CategoriesSuccessState state) {
    final category = state.selectedCategory;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category.name ?? '', style: AppStyles.medium14LightPrimary),
              SizedBox(height: 12.h),
              _buildBanner(category),
              SizedBox(height: 16.h),
            ],
          ),
        ),
        ..._buildSubCategories(state),
      ],
    );
  }

  Widget _buildBanner(Category category) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        height: 120.h,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(url: category.image),
            Container(color: AppColors.blackColor.withValues(alpha: 0.15)),
            Positioned(
              left: 12.w,
              bottom: 12.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () => _openProducts(
                  ProductListArgs(
                    title: category.name ?? 'Products',
                    categoryId: category.id,
                  ),
                ),
                child: Text('Shop Now', style: AppStyles.regular16White),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSubCategories(CategoriesSuccessState state) {
    if (state.isSubCategoriesLoading) {
      return const [SliverToBoxAdapter(child: MainLoading())];
    }
    if (state.subCategoriesError != null) {
      return [
        SliverToBoxAdapter(
          child: MainError(
            eMessage: state.subCategoriesError,
            onPress: viewModel.retrySubCategories,
          ),
        ),
      ];
    }
    final subCategories = state.subCategories!;
    if (subCategories.isEmpty) {
      return const [
        SliverToBoxAdapter(
          child: MainEmpty(message: 'No subcategories in this category'),
        ),
      ];
    }
    return [
      SliverGrid.builder(
        // More columns appear automatically on wider (unfolded) screens.
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 110.w,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 0.62,
        ),
        itemCount: subCategories.length,
        itemBuilder: (context, index) {
          final sub = subCategories[index];
          return SubCategoryItem(
            subCategory: sub,
            onTap: () => _openProducts(
              ProductListArgs(
                title: sub.name ?? 'Products',
                subcategoryId: sub.id,
              ),
            ),
          );
        },
      ),
    ];
  }

  void _openProducts(ProductListArgs args) {
    Navigator.pushNamed(context, AppRoutes.productList, arguments: args);
  }
}
