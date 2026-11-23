import 'package:ecommerce/api/model/response/common/metadata_dto.dart';
import 'package:ecommerce/api/model/response/product/sub_category_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sub_category_response_dto.g.dart';

@JsonSerializable()
class SubCategoryResponseDto {
  @JsonKey(name: 'results')
  final int? results;
  @JsonKey(name: 'metadata')
  final MetadataDto? metadata;
  @JsonKey(name: 'data')
  final List<SubcategoryDto>? data;

  SubCategoryResponseDto({this.results, this.metadata, this.data});

  factory SubCategoryResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryResponseDtoToJson(this);
}
