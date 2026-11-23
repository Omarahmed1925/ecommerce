// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_me_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMeRequestDto _$UpdateMeRequestDtoFromJson(Map<String, dynamic> json) =>
    UpdateMeRequestDto(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$UpdateMeRequestDtoToJson(UpdateMeRequestDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('email', instance.email);
  writeNotNull('phone', instance.phone);
  return val;
}
