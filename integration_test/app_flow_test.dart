// End-to-end checks on a real device against the live API.
//
// Run on the foldable emulator in each posture, e.g.:
//   adb emu unfold   -> flutter test integration_test -d emulator-5554
//   adb emu fold     -> flutter test integration_test -d emulator-5554
//
// Only public (no-login) flows are driven here, so the tests never sign in,
// place orders, or change account data.
import 'package:ecommerce/config/di/di.dart';
import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/core/utils/cache.dart';
import 'package:ecommerce/features/auth/register/register_screen.dart';
import 'package:ecommerce/features/home_screen/home_screen.dart';
import 'package:ecommerce/features/tabs/category_tab/widgets/category_side_item.dart';
import 'package:ecommerce/features/tabs/category_tab/widgets/sub_category_item.dart';
import 'package:ecommerce/features/tabs/home_tab/widgets/category_item.dart';
import 'package:ecommerce/features/tabs/product_list_tab/widgets/product_grid.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/widgets/adaptive_two_pane.dart';
import 'package:ecommerce/widgets/main_empty.dart';
import 'package:ecommerce/widgets/main_error.dart';
import 'package:ecommerce/widgets/price_text.dart';
import 'package:ecommerce/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Pumps real frames until [finder] matches (network calls are real).
Future<void> pumpUntil(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  throw TestFailure('Timed out waiting for $finder');
}

Future<void> settle(WidgetTester tester, [int frames = 10]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}

int gridChildCount(WidgetTester tester) {
  final grid = tester.widget<SliverGrid>(
    find.descendant(
      of: find.byType(ProductGrid),
      matching: find.byType(SliverGrid),
    ),
  );
  return (grid.delegate as SliverChildBuilderDelegate).childCount!;
}

Future<void> tapBack(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.arrow_back).hitTestable().first);
  await settle(tester);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await SharedPreferencesUtils.getInstance();
    configureDependencies();
  });

  testWidgets('public catalogue flow adapts to the current posture', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp(route: AppRoutes.homeScreen));
    await pumpUntil(tester, find.text('Best Sellers'));

    final context = tester.element(find.byType(HomeScreen));
    final window = MediaQuery.sizeOf(context);
    final sizeClass = WindowSizeClass.of(context);
    final features = MediaQuery.displayFeaturesOf(context);
    final seam = AppLayout.verticalSeam(features, window);
    debugPrint(
      'FOLDTEST window=$window class=$sizeClass '
      'features=${features.map((f) => '${f.type.name}/${f.state.name}@${f.bounds}').toList()}',
    );

    // Navigation chrome is chosen by width.
    expect(
      find.byType(NavigationRail),
      sizeClass.isCompact ? findsNothing : findsOneWidget,
    );
    expect(
      find.byType(BottomNavigationBar),
      sizeClass.isCompact ? findsOneWidget : findsNothing,
    );
    expect(find.byType(ProductCard), findsWidgets);

    // Home category -> filtered product list with pagination.
    final mens = find.widgetWithText(CategoryItem, "Men's Fashion");
    await pumpUntil(tester, mens);
    await tester.tap(mens);
    // Home's best-seller row also has ProductCards; wait for the list itself.
    await pumpUntil(
      tester,
      find.descendant(
        of: find.byType(ProductGrid),
        matching: find.byType(ProductCard),
      ),
    );
    expect(find.text("Men's Fashion"), findsWidgets);
    expect(gridChildCount(tester), 20, reason: 'first page');
    final scrollable = find
        .descendant(
          of: find.byType(ProductGrid),
          matching: find.byType(Scrollable),
        )
        .first;
    for (var i = 0; i < 15 && gridChildCount(tester) < 22; i++) {
      await tester.drag(scrollable, const Offset(0, -1200));
      await settle(tester, 5);
    }
    expect(gridChildCount(tester), 22, reason: 'second page loaded');

    // Sorting by price, high to low.
    await tester.tap(find.text('Default').hitTestable());
    await settle(tester, 5);
    await tester.tap(find.text('Price: high to low').last);
    await pumpUntil(tester, find.byType(ProductCard));
    await settle(tester, 5);
    final prices = tester
        .widgetList<ProductCard>(find.byType(ProductCard))
        .map((c) => c.product.price ?? 0)
        .toList();
    expect(prices.length, greaterThan(1));
    for (var i = 1; i < prices.length; i++) {
      expect(prices[i - 1], greaterThanOrEqualTo(prices[i]));
    }

    // Product details: one pane when compact, split (on the seam) otherwise.
    await tester.tap(find.byType(ProductCard).first);
    await pumpUntil(tester, find.text('Description'));
    expect(
      find.byType(AdaptiveTwoPane),
      sizeClass.isCompact ? findsNothing : findsOneWidget,
    );
    if (!sizeClass.isCompact && seam != null) {
      final startPane = tester.getRect(
        find
            .descendant(
              of: find.byType(AdaptiveTwoPane),
              matching: find.byType(SafeArea),
            )
            .first,
      );
      expect(startPane.right, closeTo(seam.left, 1), reason: 'split on fold');
    }
    final unitPrice = tester
        .widget<PriceText>(find.byType(PriceText).first)
        .product
        .finalPrice;
    expect(find.text('EGP $unitPrice'), findsWidgets);
    final increase = find
        .ancestor(
          of: find.byTooltip('Increase quantity'),
          matching: find.byType(IconButton),
        )
        .first;
    if (tester.widget<IconButton>(increase).onPressed != null) {
      await tester.tap(increase);
      await settle(tester, 3);
      expect(find.text('EGP ${unitPrice * 2}'), findsOneWidget);
    }
    await tapBack(tester);
    await tapBack(tester);

    // Categories tab -> subcategory -> product list.
    await tester.tap(find.byTooltip('Categories').first);
    final women = find.widgetWithText(CategorySideItem, "Women's Fashion");
    await pumpUntil(tester, women);
    await tester.tap(women);
    final handbags = find.widgetWithText(SubCategoryItem, 'Handbags');
    await pumpUntil(tester, handbags);
    expect(find.byType(SubCategoryItem), findsNWidgets(7));
    await tester.tap(handbags);
    // Either products or the empty state, depending on live stock.
    await pumpUntil(
      tester,
      find.byWidgetPredicate((w) => w is ProductCard || w is MainEmpty),
    );
    expect(find.text('Handbags'), findsWidgets);
    await tapBack(tester);

    // Search (matched locally; the backend keyword filter is broken).
    await tester.tap(find.byTooltip('Home').first);
    await settle(tester, 3);
    await tester.enterText(
      find.byType(TextFormField).hitTestable().first,
      'shirt',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    final results = find.descendant(
      of: find.byType(ProductGrid),
      matching: find.byType(ProductCard),
    );
    await pumpUntil(tester, results);
    final titles = tester
        .widgetList<ProductCard>(results)
        .map((c) => c.product.title!.toLowerCase());
    expect(titles, isNotEmpty);
    expect(titles, everyElement(contains('shirt')));
    await tapBack(tester);

    // Signed-out: wishlist shows the API's error with Retry (not a spinner).
    // (Signed-in behaviour is covered by signed_in_flow_test.dart.)
    await tester.tap(find.byTooltip('Wishlist').first);
    if (SharedPreferencesUtils.readData(key: CacheKeys.token) == null) {
      await pumpUntil(tester, find.byType(MainError).hitTestable());
      expect(find.text('Retry').hitTestable(), findsOneWidget);
    }

    // Account tab renders without errors.
    await tester.tap(find.byTooltip('Account').first);
    await pumpUntil(tester, find.text('Your full name').hitTestable());
    expect(find.text('Logout').hitTestable(), findsOneWidget);
  });

  testWidgets('login and register screens', (tester) async {
    await tester.pumpWidget(const MyApp(route: AppRoutes.loginScreen));
    await pumpUntil(tester, find.text('Login'));
    final create = find.text("Don't have an account? Create Account");
    await tester.ensureVisible(create);
    await tester.tap(create);
    await pumpUntil(tester, find.text('Sign up'));
    await settle(tester); // let the route transition finish

    const values = ['Omar', '01012345678', 'omar@example.com', 'Secret@123'];
    final fields = find.descendant(
      of: find.byType(RegisterScreen),
      matching: find.byType(TextFormField),
    );
    expect(fields, findsNWidgets(4));
    for (var i = 0; i < values.length; i++) {
      await tester.ensureVisible(fields.at(i));
      await tester.enterText(fields.at(i), values[i]);
    }
    await settle(tester, 3);
    expect(
      tester.widgetList<TextFormField>(fields).map((f) => f.controller!.text),
      values,
      reason: 'each field keeps its own text',
    );
  });
}
