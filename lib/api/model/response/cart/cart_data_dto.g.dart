// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDataDto _$CartDataDtoFromJson(Map<String, dynamic> json) => CartDataDto(
      id: json['_id'] as String?,
      cartOwner: json['cartOwner'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => CartProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCartPrice: (json['totalCartPrice'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CartDataDtoToJson(CartDataDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'cartOwner': instance.cartOwner,
      'products': instance.products,
      'totalCartPrice': instance.totalCartPrice,
    };
