import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/features/tabs/product_list_tab/product_list_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/utils/app_assets.dart';
import '../core/utils/app_colors.dart';
import 'custom_text_form_field.dart';

class CustomSearchRow extends StatelessWidget {
  final TextEditingController searchController;
  const CustomSearchRow({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            borderRadius: 25,
            hintText: "what do you search for?",
            controller: searchController,
            prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
            borderColor: AppColors.primaryColor,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (value) => _search(context, value),
          ),
        ),
        SizedBox(width: 12.w),
        Semantics(
          button: true,
          label: 'Cart',
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.cartTab),
            child: Image.asset(AppAssets.shoppingCartLogo),
          ),
        ),
      ],
    );
  }

  void _search(BuildContext context, String value) {
    final keyword = value.trim();
    if (keyword.isEmpty) return;
    Navigator.pushNamed(
      context,
      AppRoutes.productList,
      arguments: ProductListArgs(title: keyword, keyword: keyword),
    );
  }
}
