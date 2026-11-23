import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/app_routes.dart';
import '../core/utils/app_textstyles.dart';

class AppBarItem extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCartAction;
  const AppBarItem({
    super.key,
    required this.title,
    this.showCartAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: AppStyles.medium14LightPrimary.copyWith(fontSize: 20),
      ),
      centerTitle: true,
      actions: [
        if (showCartAction)
          IconButton(
            tooltip: 'Cart',
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.primaryColor,
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cartTab),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
