import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:ecommerce/widgets/responsive_center.dart';
import 'package:ecommerce/config/di/di.dart';
import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/features/tabs/product_list_tab/cubit/product_list_states.dart';
import 'package:ecommerce/features/tabs/product_list_tab/cubit/product_list_view_model.dart';
import 'package:ecommerce/features/tabs/product_list_tab/product_list_args.dart';
import 'package:ecommerce/features/tabs/product_list_tab/widgets/product_grid.dart';
import 'package:ecommerce/widgets/app_bar_item.dart';
import 'package:ecommerce/widgets/main_empty.dart';
import 'package:ecommerce/widgets/main_error.dart';
import 'package:ecommerce/widgets/main_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductListTab extends StatefulWidget {
  const ProductListTab({super.key});

  @override
  State<ProductListTab> createState() => _ProductListTabState();
}

class _ProductListTabState extends State<ProductListTab> {
  final ProductListViewModel viewModel = getIt<ProductListViewModel>();
  late ProductListArgs args;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    args = routeArgs is ProductListArgs
        ? routeArgs
        : const ProductListArgs(title: 'Products');
    viewModel.init(args);
  }

  @override
  void dispose() {
    viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarItem(title: args.title),
      body: ResponsiveCenter(
        maxWidth: AppLayout.contentMaxWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocBuilder<ProductListViewModel, ProductListStates>(
            bloc: viewModel,
            builder: (context, state) {
              return Column(
                children: [
                  _buildSortRow(),
                  SizedBox(height: 8.h),
                  Expanded(child: _buildBody(state)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSortRow() {
    return Row(
      children: [
        Text('Sort by', style: AppStyles.regular14Primary),
        SizedBox(width: 8.w),
        DropdownButton<ProductSort>(
          value: viewModel.sort,
          underline: const SizedBox.shrink(),
          iconEnabledColor: AppColors.primaryColor,
          style: AppStyles.medium14LightPrimary,
          items: ProductSort.values
              .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
              .toList(),
          onChanged: (sort) {
            if (sort != null) viewModel.changeSort(sort);
          },
        ),
      ],
    );
  }

  Widget _buildBody(ProductListStates state) {
    return switch (state) {
      ProductListErrorState() => MainError(
        eMessage: state.message,
        onPress: viewModel.loadFirstPage,
      ),
      ProductListEmptyState() => const MainEmpty(message: 'No products found'),
      ProductListSuccessState() => ProductGrid(
        products: state.products,
        isLoadingMore: state.isLoadingMore,
        loadMoreError: state.loadMoreError,
        onLoadMore: viewModel.loadMore,
      ),
      ProductListLoadingState() => const MainLoading(),
    };
  }
}
