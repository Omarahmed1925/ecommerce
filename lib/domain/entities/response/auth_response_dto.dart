import 'package:ecommerce/domain/entities/response/user_dto.dart';

class AuthResponseDto {
  UserDto? user;
  String? token;

  AuthResponseDto({this.user, this.token});
}
