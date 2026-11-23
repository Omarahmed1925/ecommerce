import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/domain/entities/request/shipping_address.dart';
import 'package:ecommerce/domain/entities/response/cart.dart';
import 'package:ecommerce/domain/use_cases/add_to_cart_use_case.dart';
import 'package:ecommerce/domain/use_cases/create_cash_order_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_addresses_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_cart_use_case.dart';
import 'package:ecommerce/domain/use_cases/remove_cart_item_use_case.dart';
import 'package:ecommerce/domain/use_cases/update_cart_item_quantity_use_case.dart';
import 'package:ecommerce/features/tabs/cart_tab/cubit/cart_states.dart';
import 'package:injectable/injectable.dart';

/// App-wide: provided once at the root so any screen can add to the cart.
@lazySingleton
class CartViewModel extends Cubit<CartStates> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemQuantityUseCase updateCartItemQuantityUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;
  final GetAddressesUseCase getAddressesUseCase;
  final CreateCashOrderUseCase createCashOrderUseCase;

  CartViewModel({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemQuantityUseCase,
    required this.removeCartItemUseCase,
    required this.getAddressesUseCase,
    required this.createCashOrderUseCase,
  }) : super(CartInitialState());

  Cart? _cart;

  Future<void> getCart() async {
    emit(CartLoadingState());
    try {
      _cart = await getCartUseCase.invoke();
      emit(CartSuccessState(cart: _cart!));
    } on AppExceptions catch (e) {
      emit(CartErrorState(message: e.message));
    }
  }

  /// Adds [productId]; when [quantity] > 1 the line count is then set so the
  /// cart holds exactly [quantity] more units than before.
  Future<void> addToCart(String productId, {int quantity = 1}) async {
    try {
      var cart = await addToCartUseCase.invoke(productId);
      if (quantity > 1) {
        final line = cart.items
            .where((item) => item.product?.id == productId)
            .firstOrNull;
        final newCount = (line?.count ?? 1) - 1 + quantity;
        cart = await updateCartItemQuantityUseCase.invoke(productId, newCount);
      }
      // Add/update responses may not include full product details; the cart
      // screen reloads when opened.
      _cart = null;
      emit(CartActionSuccessState(message: 'Added to cart'));
    } on AppExceptions catch (e) {
      emit(CartActionErrorState(message: e.message));
    }
  }

  Future<void> updateQuantity(String productId, int count) async {
    if (count < 1) return removeItem(productId);
    await _mutate(() => updateCartItemQuantityUseCase.invoke(productId, count));
  }

  Future<void> removeItem(String productId) async {
    await _mutate(() => removeCartItemUseCase.invoke(productId));
  }

  Future<void> checkout() async {
    final cart = _cart;
    if (cart == null || cart.cartId == null || cart.items.isEmpty) return;
    emit(CartSuccessState(cart: cart, isUpdating: true));
    try {
      final addresses = await getAddressesUseCase.invoke();
      if (addresses.isEmpty) {
        emit(
          CartActionErrorState(
            message: 'Add a shipping address from your Account first',
          ),
        );
        emit(CartSuccessState(cart: cart));
        return;
      }
      final address = addresses.first;
      await createCashOrderUseCase.invoke(
        cart.cartId!,
        ShippingAddress(
          details: address.details ?? '',
          phone: address.phone ?? '',
          city: address.city ?? '',
        ),
      );
      _cart = Cart.empty();
      emit(CartActionSuccessState(message: 'Order placed successfully'));
      emit(CartSuccessState(cart: _cart!));
    } on AppExceptions catch (e) {
      emit(CartActionErrorState(message: e.message));
      emit(CartSuccessState(cart: cart));
    }
  }

  void reset() {
    _cart = null;
    emit(CartInitialState());
  }

  Future<void> _mutate(Future<Cart> Function() action) async {
    final previous = _cart;
    if (previous != null) {
      emit(CartSuccessState(cart: previous, isUpdating: true));
    }
    try {
      var cart = await action();
      // Fall back to a fresh read if the response lacks product details.
      if (cart.items.any((item) => item.product?.title == null)) {
        cart = await getCartUseCase.invoke();
      }
      _cart = cart;
      emit(CartSuccessState(cart: cart));
    } on AppExceptions catch (e) {
      emit(CartActionErrorState(message: e.message));
      if (previous != null) emit(CartSuccessState(cart: previous));
    }
  }
}
