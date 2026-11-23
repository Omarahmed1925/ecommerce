import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final bool isLoadingMore;
  final String? loadMoreError;
  final VoidCallback onLoadMore;

  const ProductGrid({
    super.key,
    required this.products,
    required this.isLoadingMore,
    required this.loadMoreError,
    required this.onLoadMore,
  });

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300 &&
        widget.loadMoreError == null) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220.w,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 191 / 260,
          ),
          itemCount: widget.products.length,
          itemBuilder: (context, index) =>
              ProductCard(product: widget.products[index]),
        ),
        SliverToBoxAdapter(child: _buildFooter()),
      ],
    );
  }

  Widget _buildFooter() {
    if (widget.isLoadingMore) {
      return Padding(
        padding: EdgeInsets.all(16.r),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }
    if (widget.loadMoreError != null) {
      return TextButton(
        onPressed: widget.onLoadMore,
        child: Text(
          '${widget.loadMoreError} — tap to retry',
          style: AppStyles.regular14Primary,
          textAlign: TextAlign.center,
        ),
      );
    }
    return SizedBox(height: 16.h);
  }
}
