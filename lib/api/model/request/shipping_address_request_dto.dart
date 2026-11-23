import 'package:json_annotation/json_annotation.dart';

part 'shipping_address_request_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class ShippingAddressRequestDto {
  @JsonKey(name: 'shippingAddress')
  final ShippingAddressDto? shippingAddress;

  ShippingAddressRequestDto({this.shippingAddress});

  factory ShippingAddressRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressRequestDtoToJson(this);
}

@JsonSerializable()
class ShippingAddressDto {
  @JsonKey(name: 'details')
  final String? details;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'city')
  final String? city;

  ShippingAddressDto({this.details, this.phone, this.city});

  factory ShippingAddressDto.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressDtoToJson(this);
}
