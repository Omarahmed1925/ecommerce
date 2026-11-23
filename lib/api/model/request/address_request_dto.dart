import 'package:json_annotation/json_annotation.dart';

part 'address_request_dto.g.dart';

@JsonSerializable()
class AddressRequestDto {
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'details')
  final String? details;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'city')
  final String? city;

  AddressRequestDto({this.name, this.details, this.phone, this.city});

  factory AddressRequestDto.fromJson(Map<String, dynamic> json) =>
      _$AddressRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddressRequestDtoToJson(this);
}
