import 'package:ecommerce/api/model/response/cart/cart_data_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_response_dto.g.dart';

@JsonSerializable()
class CartResponseDto {
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'numOfCartItems')
  final int? numOfCartItems;
  @JsonKey(name: 'cartId')
  final String? cartId;
  @JsonKey(name: 'data')
  final CartDataDto? data;

  CartResponseDto({
    this.status,
    this.message,
    this.numOfCartItems,
    this.cartId,
    this.data,
  });

  factory CartResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CartResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseDtoToJson(this);
}
