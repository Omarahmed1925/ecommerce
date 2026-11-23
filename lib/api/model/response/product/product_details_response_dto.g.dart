// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetailsResponseDto _$ProductDetailsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    ProductDetailsResponseDto(
      data: json['data'] == null
          ? null
          : ProductDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductDetailsResponseDtoToJson(
        ProductDetailsResponseDto instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
