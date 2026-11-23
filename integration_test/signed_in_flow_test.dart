// Signed-in checks on a real device against the live API.
//
// Needs a session: sign in once in the app on the device, then run
//   flutter test integration_test/signed_in_flow_test.dart -d <device>
// Without a session the test logs "SKIPPED" and passes.
//
// Run this file on its own: `flutter test integration_test` (all files)
// reinstalls the app between files, which clears the session first.
//
// Every change is reversible and undone: it uses a product that is in
// neither the cart nor the wishlist, and restores both afterwards. It never
// checks out, edits the profile, adds addresses, or logs out.
import 'package:ecommerce/config/di/di.dart';
import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/core/utils/cache.dart';
import 'package:ecommerce/domain/entities/response/cart.dart';
import 'package:ecommerce/domain/use_cases/get_cart_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_wishlist_use_case.dart';
import 'package:ecommerce/domain/use_cases/remove_cart_item_use_case.dart';
import 'package:ecommerce/domain/use_cases/remove_from_wishlist_use_case.dart';
import 'package:ecommerce/features/tabs/cart_tab/widgets/cart_item_widget.dart';
import 'package:ecommerce/features/tabs/fav_tab/widgets/wishlist_item.dart';
import 'package:ecommerce/features/tabs/product_details_tab/widgets/add_to_cart_item.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/widgets/favorite_button.dart';
import 'package:ecommerce/widgets/product_card.dart';
import 'package:ecommerce/widgets/quantity_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> frames(WidgetTester tester, [int n = 5]) async {
  for (var i = 0; i < n; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}

/// Pumps real frames until [condition] holds (network calls are real).
Future<void> pumpUntilTrue(
  WidgetTester tester,
  Future<bool> Function() condition,
  String what, {
  Duration timeout = const Duration(seconds: 30),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await frames(tester, 2);
    if (await condition()) return;
  }
  throw TestFailure('Timed out waiting for $what');
}

Future<void> pumpUntil(WidgetTester tester, Finder finder) =>
    pumpUntilTrue(tester, () async => finder.evaluate().isNotEmpty, '$finder');

Map<String, int> cartLines(Cart cart) => {
  for (final item in cart.items)
    if (item.product?.id != null) item.product!.id!: item.count,
};

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('signed-in wishlist, cart and account flows', (tester) async {
    await SharedPreferencesUtils.getInstance();
    if (SharedPreferencesUtils.readData(key: CacheKeys.token) == null) {
      debugPrint('SKIPPED: no signed-in session on this device');
      return;
    }
    configureDependencies();
    final getCart = getIt<GetCartUseCase>();
    final getWishlist = getIt<GetWishlistUseCase>();

    // Snapshot the account so it can be restored exactly.
    final initialCart = cartLines(await getCart.invoke());
    final initialWishlist = {for (final p in await getWishlist.invoke()) p.id};
    debugPrint(
      'SIGNEDIN snapshot: ${initialCart.length} cart lines, '
      '${initialWishlist.length} wishlist items',
    );

    String? productId;
    try {
      await tester.pumpWidget(const MyApp(route: AppRoutes.homeScreen));
      await pumpUntil(tester, find.text('Best Sellers'));
      await pumpUntil(tester, find.byType(ProductCard));
      // Best sellers can sit below the fold (e.g. unfolded); bring them up.
      await tester.ensureVisible(find.byType(ProductCard).first);
      await frames(tester);
      await pumpUntil(tester, find.byType(ProductCard).hitTestable());

      // A product in neither the cart nor the wishlist, and in stock.
      final card = tester
          .widgetList<ProductCard>(find.byType(ProductCard).hitTestable())
          .firstWhere(
            (c) =>
                !initialCart.containsKey(c.product.id) &&
                !initialWishlist.contains(c.product.id),
          );
      productId = card.product.id!;
      final title = card.product.title!;
      final cardFinder = find.byWidgetPredicate(
        (w) => w is ProductCard && w.product.id == productId,
      );
      debugPrint('SIGNEDIN using product "$title"');

      // ---- Wishlist: add from the product card, see it, remove it.
      await tester.tap(
        find.descendant(of: cardFinder, matching: find.byType(FavoriteButton)),
      );
      await pumpUntilTrue(
        tester,
        () async => (await getWishlist.invoke()).any((p) => p.id == productId),
        'product saved to wishlist on the server',
      );
      expect(
        tester
            .widget<FavoriteButton>(
              find.descendant(
                of: cardFinder,
                matching: find.byType(FavoriteButton),
              ),
            )
            .isFavorite,
        isTrue,
        reason: 'heart is filled',
      );
      await tester.tap(find.byTooltip('Wishlist').first);
      final wishlistItem = find.widgetWithText(WishlistItem, title);
      await pumpUntil(tester, wishlistItem.hitTestable());
      await tester.tap(
        find.descendant(
          of: wishlistItem,
          matching: find.byType(FavoriteButton),
        ),
      );
      await pumpUntilTrue(
        tester,
        () async => wishlistItem.evaluate().isEmpty,
        'item removed from the wishlist screen',
      );
      expect(
        (await getWishlist.invoke()).map((p) => p.id).toSet(),
        initialWishlist,
        reason: 'server wishlist restored',
      );

      // ---- Cart: add 2 from details, change quantity, remove.
      await tester.tap(find.byTooltip('Home').first);
      await frames(tester);
      await tester.tap(cardFinder.hitTestable());
      await pumpUntil(tester, find.text('Description'));
      final increase = find
          .ancestor(
            of: find.byTooltip('Increase quantity'),
            matching: find.byType(IconButton),
          )
          .first;
      var expected = 1;
      if (tester.widget<IconButton>(increase).onPressed != null) {
        await tester.tap(increase);
        await frames(tester, 2);
        expected = 2;
      }
      await tester.tap(find.byType(AddToCartItem));
      await pumpUntilTrue(
        tester,
        () async => cartLines(await getCart.invoke())[productId] == expected,
        'cart has $expected of the product',
      );

      await tester.tap(find.byTooltip('Cart').first);
      final cartItem = find.widgetWithText(CartItemWidget, title);
      await pumpUntil(tester, cartItem);
      int shownQuantity() => tester
          .widget<QuantityItem>(
            find.descendant(of: cartItem, matching: find.byType(QuantityItem)),
          )
          .quantity;
      expect(shownQuantity(), expected);
      final serverTotal = (await getCart.invoke()).totalCartPrice;
      expect(find.text('EGP $serverTotal'), findsOneWidget, reason: 'total');

      Future<void> tapInCart(String tooltip) async {
        await tester.tap(
          find.descendant(of: cartItem, matching: find.byTooltip(tooltip)),
        );
      }

      await tapInCart('Increase quantity');
      await pumpUntilTrue(
        tester,
        () async => shownQuantity() == expected + 1,
        'quantity increased on screen',
      );
      expect(cartLines(await getCart.invoke())[productId], expected + 1);

      await tapInCart('Decrease quantity');
      await pumpUntilTrue(
        tester,
        () async => shownQuantity() == expected,
        'quantity decreased on screen',
      );

      await tapInCart('Remove from cart');
      await pumpUntilTrue(
        tester,
        () async => cartItem.evaluate().isEmpty,
        'item removed from the cart screen',
      );
      expect(
        cartLines(await getCart.invoke()),
        initialCart,
        reason: 'server cart restored',
      );

      // ---- Account: real profile data, addresses loaded (no edits made).
      // Back out of Cart and Product Details to the home shell.
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.byIcon(Icons.arrow_back).hitTestable().first);
        await frames(tester);
      }
      await pumpUntil(tester, find.byTooltip('Account'));
      await tester.tap(find.byTooltip('Account').first);
      await pumpUntil(tester, find.text('Your full name').hitTestable());
      await pumpUntilTrue(
        tester,
        () async => find.text('Loading…').evaluate().isEmpty,
        'addresses loaded',
      );
      final welcome = tester
          .widgetList<Text>(find.textContaining('Welcome, '))
          .single
          .data!;
      expect(welcome.trim(), isNot('Welcome,'), reason: 'name is shown');
      expect(find.text('Logout').hitTestable(), findsOneWidget);
    } finally {
      // Undo anything a failed step may have left behind.
      if (productId != null) {
        if (cartLines(await getCart.invoke()).containsKey(productId) &&
            !initialCart.containsKey(productId)) {
          await getIt<RemoveCartItemUseCase>().invoke(productId);
        }
        if ((await getWishlist.invoke()).any((p) => p.id == productId) &&
            !initialWishlist.contains(productId)) {
          await getIt<RemoveFromWishlistUseCase>().invoke(productId);
        }
      }
      final finalCart = cartLines(await getCart.invoke());
      final finalWishlist = {for (final p in await getWishlist.invoke()) p.id};
      debugPrint(
        'SIGNEDIN restored: cart=${_same(finalCart, initialCart)} '
        'wishlist=${finalWishlist.length == initialWishlist.length && finalWishlist.containsAll(initialWishlist)}',
      );
    }
  });
}

bool _same(Map<String, int> a, Map<String, int> b) =>
    a.length == b.length && a.entries.every((e) => b[e.key] == e.value);
