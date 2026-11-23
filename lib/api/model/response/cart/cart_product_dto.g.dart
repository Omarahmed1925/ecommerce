// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartProductDto _$CartProductDtoFromJson(Map<String, dynamic> json) =>
    CartProductDto(
      count: (json['count'] as num?)?.toInt(),
      id: json['_id'] as String?,
      price: (json['price'] as num?)?.toInt(),
      product: productRefFromJson(json['product']),
    );

Map<String, dynamic> _$CartProductDtoToJson(CartProductDto instance) =>
    <String, dynamic>{
      'count': instance.count,
      '_id': instance.id,
      'price': instance.price,
    };
