// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressResponseDto _$AddressResponseDtoFromJson(Map<String, dynamic> json) =>
    AddressResponseDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AddressDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddressResponseDtoToJson(AddressResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
