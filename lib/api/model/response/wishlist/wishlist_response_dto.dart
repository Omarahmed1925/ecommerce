import 'package:ecommerce/api/model/response/product/product_dto.dart';
import 'package:ecommerce/api/model/response/product/product_ref_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wishlist_response_dto.g.dart';

@JsonSerializable()
class WishlistResponseDto {
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'count')
  final int? count;

  /// Full products on GET; product ids on add/remove.
  @JsonKey(name: 'data', fromJson: productRefListFromJson, includeToJson: false)
  final List<ProductDto>? data;

  WishlistResponseDto({this.status, this.message, this.count, this.data});

  factory WishlistResponseDto.fromJson(Map<String, dynamic> json) =>
      _$WishlistResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistResponseDtoToJson(this);
}
