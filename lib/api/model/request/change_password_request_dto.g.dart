// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordRequestDto _$ChangePasswordRequestDtoFromJson(
        Map<String, dynamic> json) =>
    ChangePasswordRequestDto(
      currentPassword: json['currentPassword'] as String?,
      password: json['password'] as String?,
      rePassword: json['rePassword'] as String?,
    );

Map<String, dynamic> _$ChangePasswordRequestDtoToJson(
        ChangePasswordRequestDto instance) =>
    <String, dynamic>{
      'currentPassword': instance.currentPassword,
      'password': instance.password,
      'rePassword': instance.rePassword,
    };
