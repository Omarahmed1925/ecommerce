import 'package:ecommerce/api/model/response/category/data_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import '../common/metadata_dto.dart';

part 'brands_response_dto.g.dart';

@JsonSerializable()
class BrandsResponseDto {
  @JsonKey(name: "results")
  final int? results;
  @JsonKey(name: "metadata")
  final MetadataDto? metadata;
  @JsonKey(name: "data")
  final List<CategoryDataDto>? data;

  BrandsResponseDto({this.results, this.metadata, this.data});

  factory BrandsResponseDto.fromJson(Map<String, dynamic> json) {
    return _$BrandsResponseDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$BrandsResponseDtoToJson(this);
  }
}
