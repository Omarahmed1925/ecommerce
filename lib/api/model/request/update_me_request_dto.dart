import 'package:json_annotation/json_annotation.dart';

part 'update_me_request_dto.g.dart';

/// Only the fields being changed are sent.
@JsonSerializable(includeIfNull: false)
class UpdateMeRequestDto {
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'phone')
  final String? phone;

  UpdateMeRequestDto({this.name, this.email, this.phone});

  factory UpdateMeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateMeRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateMeRequestDtoToJson(this);
}
