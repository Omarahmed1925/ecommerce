import 'package:ecommerce/api/mapper/product_mapper.dart';
import 'package:ecommerce/api/model/response/cart/cart_product_dto.dart';
import 'package:ecommerce/api/model/response/cart/cart_response_dto.dart';
import 'package:ecommerce/domain/entities/response/cart.dart';
import 'package:ecommerce/domain/entities/response/cart_item.dart';

extension CartMapper on CartResponseDto {
  Cart toCart() {
    return Cart(
      cartId: cartId ?? data?.id,
      numOfCartItems: numOfCartItems ?? data?.products?.length ?? 0,
      totalCartPrice: data?.totalCartPrice ?? 0,
      items: data?.products?.map((dto) => dto.toCartItem()).toList() ?? [],
    );
  }
}

extension CartItemMapper on CartProductDto {
  CartItem toCartItem() {
    return CartItem(
      id: id,
      count: count ?? 0,
      price: price ?? 0,
      product: product?.toProduct(),
    );
  }
}
