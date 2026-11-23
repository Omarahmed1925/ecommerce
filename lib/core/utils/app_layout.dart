import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter/widgets.dart';

/// Material 3 window size classes, the single breakpoint vocabulary of the
/// app. Layout decisions branch on the available width, never on the device.
enum WindowSizeClass {
  compact,
  medium,
  expanded,
  large,
  extraLarge;

  static WindowSizeClass fromWidth(double width) => switch (width) {
    < 600 => compact,
    < 840 => medium,
    < 1200 => expanded,
    < 1600 => large,
    _ => extraLarge,
  };

  /// Rebuilds the caller only when the window size changes.
  static WindowSizeClass of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  bool get isCompact => this == compact;
}

abstract final class AppLayout {
  /// The Figma frame every `.w/.h/.sp/.r` value was measured against.
  static const Size baseDesignSize = Size(430, 932);

  /// flutter_screenutil scales linearly with the window. On an unfolded
  /// foldable (~840dp wide) that would double every size, and in landscape
  /// it would shrink heights to ~40%. Clamping keeps components close to
  /// their designed size; extra space is used by the adaptive layouts.
  static const double minScale = 0.85;
  static const double maxScale = 1.15;

  /// Readable max widths for single-pane content on wide windows.
  static const double formMaxWidth = 480;
  static const double listMaxWidth = 720;
  static const double contentMaxWidth = 1040;

  /// The design size to hand to `ScreenUtilInit` for [window] so the
  /// resulting scale factors stay within [minScale]..[maxScale].
  static Size designSizeFor(Size window) {
    if (window.isEmpty) return baseDesignSize;
    final scaleW = (window.width / baseDesignSize.width).clamp(
      minScale,
      maxScale,
    );
    final scaleH = (window.height / baseDesignSize.height).clamp(
      minScale,
      maxScale,
    );
    return Size(window.width / scaleW, window.height / scaleH);
  }

  /// A fold or hinge that runs the full height of the window (book posture),
  /// in window coordinates; `null` when there is none.
  static Rect? verticalSeam(List<DisplayFeature> features, Size window) {
    for (final feature in features) {
      if (feature.type != DisplayFeatureType.fold &&
          feature.type != DisplayFeatureType.hinge) {
        continue;
      }
      final bounds = feature.bounds;
      final spansHeight = bounds.top <= 0 && bounds.bottom >= window.height;
      if (spansHeight && bounds.left > 0 && bounds.right < window.width) {
        return bounds;
      }
    }
    return null;
  }

  /// Whether content placed across [verticalSeam] would be hidden or bent:
  /// a physical hinge gap, or a fold that is half-opened.
  static bool seamObstructs(List<DisplayFeature> features, Rect seam) {
    return features.any(
      (f) =>
          f.bounds == seam &&
          (f.bounds.width > 0 ||
              f.state == DisplayFeatureState.postureHalfOpened),
    );
  }
}
