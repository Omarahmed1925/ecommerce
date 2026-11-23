import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) return _fallback();
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
          strokeWidth: 2,
        ),
      ),
      errorWidget: (context, url, error) => _fallback(),
    );
  }

  Widget _fallback() => SizedBox(
    width: width,
    height: height,
    child: const Icon(
      Icons.image_not_supported_outlined,
      color: AppColors.grayColor,
    ),
  );
}
