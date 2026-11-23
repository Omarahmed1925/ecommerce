import 'package:ecommerce/api/mapper/user_mappper.dart';
import 'package:ecommerce/api/model/response/auth_response.dart';
import 'package:ecommerce/domain/entities/response/auth_response_dto.dart';

extension AuthResponseMapper on AuthResponse {
  AuthResponseDto toAuthResponseDto() {
    return AuthResponseDto(token: token, user: user?.toUserDto());
  }
}
