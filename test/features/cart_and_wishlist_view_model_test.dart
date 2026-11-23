import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/domain/entities/request/address_request.dart';
import 'package:ecommerce/domain/entities/request/change_password_request.dart';
import 'package:ecommerce/domain/entities/request/shipping_address.dart';
import 'package:ecommerce/domain/entities/request/update_profile_request.dart';
import 'package:ecommerce/domain/entities/response/address.dart';
import 'package:ecommerce/domain/entities/response/cart.dart';
import 'package:ecommerce/domain/entities/response/cart_item.dart';
import 'package:ecommerce/domain/entities/response/product.dart';
import 'package:ecommerce/domain/entities/response/user_profile.dart';
import 'package:ecommerce/domain/repos/cart_repo.dart';
import 'package:ecommerce/domain/repos/order_repo.dart';
import 'package:ecommerce/domain/repos/user_repo.dart';
import 'package:ecommerce/domain/repos/wishlist_repo.dart';
import 'package:ecommerce/domain/use_cases/add_to_cart_use_case.dart';
import 'package:ecommerce/domain/use_cases/add_to_wishlist_use_case.dart';
import 'package:ecommerce/domain/use_cases/create_cash_order_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_addresses_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_cart_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_wishlist_use_case.dart';
import 'package:ecommerce/domain/use_cases/remove_cart_item_use_case.dart';
import 'package:ecommerce/domain/use_cases/remove_from_wishlist_use_case.dart';
import 'package:ecommerce/domain/use_cases/update_cart_item_quantity_use_case.dart';
import 'package:ecommerce/features/tabs/cart_tab/cubit/cart_states.dart';
import 'package:ecommerce/features/tabs/cart_tab/cubit/cart_view_model.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_states.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCartRepo implements CartRepo {
  int existingCount = 0;
  final updates = <(String, int)>[];

  Cart _cartWith(String id, int count) => Cart(
    cartId: 'c',
    numOfCartItems: 1,
    totalCartPrice: 0,
    items: [
      CartItem(
        id: 'l',
        count: count,
        price: 10,
        product: Product(id: id),
      ),
    ],
  );

  @override
  Future<Cart> addToCart(String productId) async =>
      _cartWith(productId, ++existingCount);

  @override
  Future<Cart> updateItemQuantity(String productId, int count) async {
    updates.add((productId, count));
    return _cartWith(productId, count);
  }

  @override
  Future<Cart> getCart() async => Cart.empty();

  @override
  Future<Cart> removeItem(String productId) async => Cart.empty();
}

class FakeOrderRepo implements OrderRepo {
  @override
  Future<void> createCashOrder(String cartId, ShippingAddress address) async {}
}

class FakeUserRepo implements UserRepo {
  @override
  Future<List<Address>> getAddresses() async => [];
  @override
  Future<List<Address>> addAddress(AddressRequest request) async => [];
  @override
  Future<void> changePassword(ChangePasswordRequest request) async {}
  @override
  UserProfile getCachedProfile() => UserProfile();
  @override
  Future<void> logout() async {}
  @override
  Future<UserProfile> updateProfile(UpdateProfileRequest request) async =>
      UserProfile();
}

class FakeWishlistRepo implements WishlistRepo {
  bool failNext = false;

  @override
  Future<List<Product>> getWishlist() async => [Product(id: 'a')];

  @override
  Future<List<String>> addToWishlist(String productId) async {
    if (failNext) throw ServerException(message: 'boom', statusCode: 500);
    return ['a', productId];
  }

  @override
  Future<List<String>> removeFromWishlist(String productId) async => [];
}

void main() {
  group('CartViewModel.addToCart', () {
    late FakeCartRepo repo;
    late CartViewModel viewModel;

    setUp(() {
      repo = FakeCartRepo();
      final userRepo = FakeUserRepo();
      viewModel = CartViewModel(
        getCartUseCase: GetCartUseCase(cartRepo: repo),
        addToCartUseCase: AddToCartUseCase(cartRepo: repo),
        updateCartItemQuantityUseCase: UpdateCartItemQuantityUseCase(
          cartRepo: repo,
        ),
        removeCartItemUseCase: RemoveCartItemUseCase(cartRepo: repo),
        getAddressesUseCase: GetAddressesUseCase(userRepo: userRepo),
        createCashOrderUseCase: CreateCashOrderUseCase(
          orderRepo: FakeOrderRepo(),
        ),
      );
    });

    tearDown(() => viewModel.close());

    test('quantity 1 only adds', () async {
      await viewModel.addToCart('p');
      expect(repo.updates, isEmpty);
      expect(viewModel.state, isA<CartActionSuccessState>());
    });

    test('quantity 3 on an item already in the cart adds 3 units', () async {
      repo.existingCount = 2; // add() makes it 3
      await viewModel.addToCart('p', quantity: 3);
      expect(repo.updates, [('p', 5)]);
    });
  });

  group('WishlistViewModel.toggleFavorite', () {
    late FakeWishlistRepo repo;
    late WishlistViewModel viewModel;

    setUp(() async {
      repo = FakeWishlistRepo();
      viewModel = WishlistViewModel(
        getWishlistUseCase: GetWishlistUseCase(wishlistRepo: repo),
        addToWishlistUseCase: AddToWishlistUseCase(wishlistRepo: repo),
        removeFromWishlistUseCase: RemoveFromWishlistUseCase(
          wishlistRepo: repo,
        ),
      );
      await viewModel.getWishlist();
    });

    tearDown(() => viewModel.close());

    test('adds and syncs ids from the response', () async {
      await viewModel.toggleFavorite(Product(id: 'b'));
      expect(viewModel.isFavorite('a'), isTrue);
      expect(viewModel.isFavorite('b'), isTrue);
    });

    test('removes', () async {
      await viewModel.toggleFavorite(Product(id: 'a'));
      expect(viewModel.isFavorite('a'), isFalse);
      final state = viewModel.state as WishlistSuccessState;
      expect(state.products, isEmpty);
    });

    test('rolls back the optimistic update on failure', () async {
      repo.failNext = true;
      final emitted = <WishlistStates>[];
      final sub = viewModel.stream.listen(emitted.add);
      await viewModel.toggleFavorite(Product(id: 'b'));
      await Future<void>.delayed(Duration.zero); // flush async stream events
      await sub.cancel();

      expect(viewModel.isFavorite('b'), isFalse);
      expect(emitted.whereType<WishlistActionErrorState>(), hasLength(1));
    });
  });
}
