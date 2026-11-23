import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:flutter/material.dart';

/// Lays [start] and [end] side by side.
///
/// On a foldable in book posture the split is placed exactly on the vertical
/// fold/hinge, so each pane sits on its own half and nothing is drawn under
/// the hinge. Otherwise the width is shared by [startFlex]/[endFlex].
///
/// Seam alignment needs window coordinates, so it is applied only when this
/// widget spans the full window width (e.g. as a route's Scaffold body).
class AdaptiveTwoPane extends StatelessWidget {
  final Widget start;
  final Widget end;
  final int startFlex;
  final int endFlex;

  const AdaptiveTwoPane({
    super.key,
    required this.start,
    required this.end,
    this.startFlex = 1,
    this.endFlex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final window = MediaQuery.sizeOf(context);
    final features = MediaQuery.displayFeaturesOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final spansWindow = (constraints.maxWidth - window.width).abs() < 1;
        final seam = spansWindow
            ? AppLayout.verticalSeam(features, window)
            : null;
        if (seam != null) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: seam.left, child: start),
              SizedBox(width: seam.width),
              Expanded(child: end),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: startFlex, child: start),
            Expanded(flex: endFlex, child: end),
          ],
        );
      },
    );
  }
}
