import 'dart:math' as math;

import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:flutter/material.dart';

/// Caps [child] to [maxWidth] and centers it horizontally, so single-pane
/// content stays readable on unfolded foldables and tablets.
///
/// When it spans the whole window and a hinge (or a half-opened fold) splits
/// the screen, the content is kept on one side instead of under the seam.
class ResponsiveCenter extends StatelessWidget {
  final double maxWidth;
  final Widget child;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = AppLayout.listMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final window = MediaQuery.sizeOf(context);
    final features = MediaQuery.displayFeaturesOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final spansWindow = (constraints.maxWidth - window.width).abs() < 1;
        final seam = AppLayout.verticalSeam(features, window);
        if (spansWindow &&
            seam != null &&
            AppLayout.seamObstructs(features, seam)) {
          return DisplayFeatureSubScreen(child: _capped(constraints));
        }
        return _capped(constraints);
      },
    );
  }

  Widget _capped(BoxConstraints constraints) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: math.min(maxWidth, constraints.maxWidth),
        child: child,
      ),
    );
  }
}
