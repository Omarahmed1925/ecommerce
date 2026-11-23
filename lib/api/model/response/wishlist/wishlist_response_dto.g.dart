// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistResponseDto _$WishlistResponseDtoFromJson(Map<String, dynamic> json) =>
    WishlistResponseDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      count: (json['count'] as num?)?.toInt(),
      data: productRefListFromJson(json['data']),
    );

Map<String, dynamic> _$WishlistResponseDtoToJson(
        WishlistResponseDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'count': instance.count,
    };
