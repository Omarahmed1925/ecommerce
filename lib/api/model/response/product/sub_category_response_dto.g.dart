// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategoryResponseDto _$SubCategoryResponseDtoFromJson(
        Map<String, dynamic> json) =>
    SubCategoryResponseDto(
      results: (json['results'] as num?)?.toInt(),
      metadata: json['metadata'] == null
          ? null
          : MetadataDto.fromJson(json['metadata'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SubcategoryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubCategoryResponseDtoToJson(
        SubCategoryResponseDto instance) =>
    <String, dynamic>{
      'results': instance.results,
      'metadata': instance.metadata,
      'data': instance.data,
    };
