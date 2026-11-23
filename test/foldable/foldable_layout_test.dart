import 'dart:ui';

import 'package:ecommerce/core/utils/app_assets.dart';
import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:ecommerce/domain/entities/response/cart_item.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/features/tabs/cart_tab/widgets/cart_item_widget.dart';
import 'package:ecommerce/features/tabs/fav_tab/widgets/wishlist_item.dart';
import 'package:ecommerce/features/tabs/product_details_tab/widgets/sold_item.dart';
import 'package:ecommerce/widgets/adaptive_navigation_shell.dart';
import 'package:ecommerce/widgets/adaptive_two_pane.dart';
import 'package:ecommerce/widgets/price_text.dart';
import 'package:ecommerce/widgets/product_item.dart';
import 'package:ecommerce/widgets/quantity_item.dart';
import 'package:ecommerce/widgets/responsive_center.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Logical window sizes of common foldable states.
const foldedCover = Size(360, 780); // outer screen, portrait
const foldedLandscape = Size(780, 360);
const unfolded = Size(884, 1000); // inner screen, book posture
const dualScreen = Size(1114, 720); // two panels with a hinge gap

/// A full-height fold down the middle of [unfolded].
final centreFold = DisplayFeature(
  bounds: Rect.fromLTWH(unfolded.width / 2, 0, 0, unfolded.height),
  type: DisplayFeatureType.fold,
  state: DisplayFeatureState.postureFlat,
);

/// A 34dp physical hinge between the two panels of [dualScreen].
final hingeGap = DisplayFeature(
  bounds: Rect.fromLTWH(540, 0, 34, dualScreen.height),
  type: DisplayFeatureType.hinge,
  state: DisplayFeatureState.postureFlat,
);

Future<void> pumpAt(
  WidgetTester tester,
  Size size,
  Widget child, {
  List<DisplayFeature> features = const [],
  double textScale = 1,
}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = size
    ..displayFeatures = features;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  await tester.pumpWidget(
    Builder(
      builder: (context) => ScreenUtilInit(
        designSize: AppLayout.designSizeFor(MediaQuery.sizeOf(context)),
        minTextAdapt: true,
        builder: (_, _) => MaterialApp(home: child),
      ),
    ),
  );
  await tester.pump();
}

const destinations = [
  AdaptiveDestination(
    label: 'Home',
    selectedIcon: AppAssets.selectedHome,
    unselectedIcon: AppAssets.unselectedHome,
  ),
  AdaptiveDestination(
    label: 'Categories',
    selectedIcon: AppAssets.selectedCategories,
    unselectedIcon: AppAssets.unselectedCategories,
  ),
];

final product = Product(
  id: 'p',
  title: 'A very long product title that would wrap onto several lines',
  description: 'Description',
  price: 1200,
  priceAfterDiscount: 999,
  ratingsAverage: 4.6,
);

void main() {
  // Fonts are bundled at build time; never fetch them during tests.
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('AppLayout', () {
    test('size classes follow Material 3 breakpoints', () {
      expect(WindowSizeClass.fromWidth(foldedCover.width).isCompact, isTrue);
      expect(
        WindowSizeClass.fromWidth(unfolded.width),
        WindowSizeClass.expanded,
      );
      expect(WindowSizeClass.fromWidth(700), WindowSizeClass.medium);
    });

    test('design size keeps screenutil scale within the clamp', () {
      for (final window in [foldedCover, foldedLandscape, unfolded]) {
        final design = AppLayout.designSizeFor(window);
        final scaleW = window.width / design.width;
        final scaleH = window.height / design.height;
        expect(scaleW, inInclusiveRange(0.85, 1.15), reason: '$window');
        expect(scaleH, inInclusiveRange(0.85, 1.15), reason: '$window');
      }
      expect(
        AppLayout.designSizeFor(AppLayout.baseDesignSize),
        AppLayout.baseDesignSize,
      );
    });

    test('detects a vertical seam and whether it obstructs', () {
      expect(AppLayout.verticalSeam([centreFold], unfolded), centreFold.bounds);
      expect(AppLayout.seamObstructs([centreFold], centreFold.bounds), isFalse);
      expect(AppLayout.seamObstructs([hingeGap], hingeGap.bounds), isTrue);
      final halfOpened = DisplayFeature(
        bounds: centreFold.bounds,
        type: DisplayFeatureType.fold,
        state: DisplayFeatureState.postureHalfOpened,
      );
      expect(AppLayout.seamObstructs([halfOpened], halfOpened.bounds), isTrue);
    });
  });

  group('AdaptiveNavigationShell', () {
    Widget shell() => AdaptiveNavigationShell(
      selectedIndex: 0,
      onDestinationSelected: (_) {},
      destinations: destinations,
      body: const SizedBox.expand(),
    );

    testWidgets('bottom bar when folded', (tester) async {
      await pumpAt(tester, foldedCover, shell());
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('tab state survives fold and unfold', (tester) async {
      Widget statefulShell() => AdaptiveNavigationShell(
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        destinations: destinations,
        body: const _Counter(),
      );
      await pumpAt(tester, unfolded, statefulShell(), features: [centreFold]);
      await tester.tap(find.byType(_Counter));
      await tester.pump();
      expect(find.text('taps: 1'), findsOneWidget);

      // Fold: rail -> bottom bar. The tab must not be rebuilt from scratch.
      tester.view.physicalSize = foldedCover;
      tester.view.displayFeatures = [];
      await tester.pump();
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('taps: 1'), findsOneWidget);

      // Unfold again.
      tester.view.physicalSize = unfolded;
      await tester.pump();
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.text('taps: 1'), findsOneWidget);
    });

    testWidgets('navigation rail when unfolded or landscape', (tester) async {
      for (final size in [unfolded, foldedLandscape]) {
        await pumpAt(tester, size, shell(), features: [centreFold]);
        expect(find.byType(NavigationRail), findsOneWidget, reason: '$size');
        expect(find.byType(BottomNavigationBar), findsNothing);
      }
    });
  });

  group('AdaptiveTwoPane', () {
    const startKey = Key('start');
    const endKey = Key('end');
    final panes = const AdaptiveTwoPane(
      start: SizedBox.expand(key: startKey),
      end: SizedBox.expand(key: endKey),
    );

    testWidgets('splits exactly on the fold', (tester) async {
      await pumpAt(
        tester,
        unfolded,
        Scaffold(body: panes),
        features: [centreFold],
      );
      expect(tester.getSize(find.byKey(startKey)).width, unfolded.width / 2);
      expect(tester.getTopLeft(find.byKey(endKey)).dx, unfolded.width / 2);
    });

    testWidgets('keeps both panes off the hinge gap', (tester) async {
      await pumpAt(
        tester,
        dualScreen,
        Scaffold(body: panes),
        features: [hingeGap],
      );
      expect(tester.getTopRight(find.byKey(startKey)).dx, hingeGap.bounds.left);
      expect(tester.getTopLeft(find.byKey(endKey)).dx, hingeGap.bounds.right);
    });
  });

  testWidgets('ResponsiveCenter stays on one side of a hinge', (tester) async {
    const key = Key('content');
    await pumpAt(
      tester,
      dualScreen,
      const Scaffold(
        body: ResponsiveCenter(child: SizedBox.expand(key: key)),
      ),
      features: [hingeGap],
    );
    final rect = tester.getRect(find.byKey(key));
    expect(rect.right, lessThanOrEqualTo(hingeGap.bounds.left));
  });

  testWidgets('ResponsiveCenter caps width when unfolded', (tester) async {
    const key = Key('content');
    await pumpAt(
      tester,
      unfolded,
      const Scaffold(
        body: ResponsiveCenter(child: SizedBox.expand(key: key)),
      ),
      features: [centreFold],
    );
    expect(tester.getSize(find.byKey(key)).width, AppLayout.listMaxWidth);
  });

  group('components do not overflow', () {
    final cases = {
      'folded': foldedCover,
      'folded landscape': foldedLandscape,
      'unfolded': unfolded,
    };

    for (final MapEntry(key: name, value: size) in cases.entries) {
      for (final textScale in [1.0, 1.5]) {
        testWidgets('$name @ ${textScale}x text', (tester) async {
          await pumpAt(
            tester,
            size,
            textScale: textScale,
            Scaffold(
              body: ResponsiveCenter(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    CartItemWidget(
                      item: CartItem(
                        id: 'l',
                        count: 2,
                        price: 999,
                        product: product,
                      ),
                      enabled: true,
                      onTap: () {},
                      onDelete: () {},
                      onIncrement: () {},
                      onDecrement: () {},
                    ),
                    const SizedBox(height: 16),
                    WishlistItem(
                      product: product,
                      onTap: () {},
                      onRemove: () {},
                      onAddToCart: () {},
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: SoldItem(price: '689'),
                    ),
                    const SizedBox(height: 16),
                    // Narrowest grid cell: 2 columns on a 360dp cover screen.
                    SizedBox(
                      width: 156,
                      height: 156 * 260 / 191,
                      child: ProductItem(
                        prod: product,
                        isFavorite: false,
                        onTap: () {},
                        onFavoriteTap: () {},
                        onAddToCart: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          expect(tester.takeException(), isNull);
          // When price and action share a line, the action sits at the
          // card's right edge (as in the design), not squeezed next to the
          // price. (On very narrow screens it wraps below instead.)
          void expectRightAligned(Finder card, Finder price, Finder action) {
            final priceRect = tester.getRect(price);
            final actionRect = tester.getRect(action);
            final sameLine = actionRect.top < priceRect.bottom;
            if (sameLine) {
              expect(
                actionRect.right,
                greaterThan(tester.getRect(card).right - 24),
                reason: '$action is right-aligned',
              );
            } else {
              expect(actionRect.top, greaterThanOrEqualTo(priceRect.bottom));
            }
          }

          expectRightAligned(
            find.byType(CartItemWidget),
            find.text('EGP 999').first,
            find.byType(QuantityItem),
          );
          expectRightAligned(
            find.byType(WishlistItem),
            find.descendant(
              of: find.byType(WishlistItem),
              matching: find.byType(PriceText),
            ),
            find.widgetWithText(ElevatedButton, 'Add to Cart'),
          );
          // The rating is shown in full, not truncated to "Review ...".
          final rating = find.text('Review (4.6)');
          // Short landscape windows build the card lazily; scroll to it.
          await tester.scrollUntilVisible(
            rating,
            200,
            scrollable: find.byType(Scrollable).first,
          );
          expect(rating, findsOneWidget);
          expect(tester.takeException(), isNull);
          final painter = TextPainter(
            text: TextSpan(
              text: 'Review (4.6)',
              style: tester.widget<Text>(rating).style,
            ),
            textDirection: TextDirection.ltr,
            textScaler: TextScaler.linear(textScale),
          )..layout();
          expect(
            tester.getSize(rating).width,
            greaterThanOrEqualTo(painter.width - 0.5),
            reason: 'rating text must not be truncated',
          );
        });
      }
    }
  });
}

/// Stands in for a tab with its own state (selected category, scroll, ...).
class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int taps = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => taps++),
    child: ColoredBox(
      color: Colors.white,
      child: Center(child: Text('taps: $taps')),
    ),
  );
}
