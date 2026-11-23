import 'package:ecommerce/api/model/response/product/product_dto.dart';
import 'package:ecommerce/api/model/response/product/product_ref_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_product_dto.g.dart';

@JsonSerializable()
class CartProductDto {
  @JsonKey(name: 'count')
  final int? count;
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'price')
  final int? price;
  @JsonKey(name: 'product', fromJson: productRefFromJson, includeToJson: false)
  final ProductDto? product;

  CartProductDto({this.count, this.id, this.price, this.product});

  factory CartProductDto.fromJson(Map<String, dynamic> json) =>
      _$CartProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartProductDtoToJson(this);
}
