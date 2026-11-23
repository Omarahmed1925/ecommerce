import 'package:json_annotation/json_annotation.dart';

part 'cart_quantity_request_dto.g.dart';

@JsonSerializable()
class CartQuantityRequestDto {
  /// Sent as a string, as in the Postman collection.
  @JsonKey(name: 'count')
  final String? count;

  CartQuantityRequestDto({this.count});

  factory CartQuantityRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CartQuantityRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CartQuantityRequestDtoToJson(this);
}
