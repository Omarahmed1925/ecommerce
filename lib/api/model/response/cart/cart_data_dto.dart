import 'package:ecommerce/api/model/response/cart/cart_product_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_data_dto.g.dart';

@JsonSerializable()
class CartDataDto {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'cartOwner')
  final String? cartOwner;
  @JsonKey(name: 'products')
  final List<CartProductDto>? products;
  @JsonKey(name: 'totalCartPrice')
  final int? totalCartPrice;

  CartDataDto({this.id, this.cartOwner, this.products, this.totalCartPrice});

  factory CartDataDto.fromJson(Map<String, dynamic> json) =>
      _$CartDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartDataDtoToJson(this);
}
