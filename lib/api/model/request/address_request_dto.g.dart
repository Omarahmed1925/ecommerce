// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressRequestDto _$AddressRequestDtoFromJson(Map<String, dynamic> json) =>
    AddressRequestDto(
      name: json['name'] as String?,
      details: json['details'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$AddressRequestDtoToJson(AddressRequestDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'details': instance.details,
      'phone': instance.phone,
      'city': instance.city,
    };
