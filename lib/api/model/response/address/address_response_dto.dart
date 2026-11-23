import 'package:ecommerce/api/model/response/address/address_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_response_dto.g.dart';

@JsonSerializable()
class AddressResponseDto {
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'data')
  final List<AddressDto>? data;

  AddressResponseDto({this.status, this.message, this.data});

  factory AddressResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AddressResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddressResponseDtoToJson(this);
}
