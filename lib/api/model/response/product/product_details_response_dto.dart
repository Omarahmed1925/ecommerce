import 'package:ecommerce/api/model/response/product/product_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_details_response_dto.g.dart';

@JsonSerializable()
class ProductDetailsResponseDto {
  @JsonKey(name: 'data')
  final ProductDto? data;

  ProductDetailsResponseDto({this.data});

  factory ProductDetailsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailsResponseDtoToJson(this);
}
