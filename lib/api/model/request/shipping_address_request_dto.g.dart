// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingAddressRequestDto _$ShippingAddressRequestDtoFromJson(
        Map<String, dynamic> json) =>
    ShippingAddressRequestDto(
      shippingAddress: json['shippingAddress'] == null
          ? null
          : ShippingAddressDto.fromJson(
              json['shippingAddress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShippingAddressRequestDtoToJson(
        ShippingAddressRequestDto instance) =>
    <String, dynamic>{
      'shippingAddress': instance.shippingAddress?.toJson(),
    };

ShippingAddressDto _$ShippingAddressDtoFromJson(Map<String, dynamic> json) =>
    ShippingAddressDto(
      details: json['details'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$ShippingAddressDtoToJson(ShippingAddressDto instance) =>
    <String, dynamic>{
      'details': instance.details,
      'phone': instance.phone,
      'city': instance.city,
    };
