import 'package:ecommerce/api/model/request/register_request.dart';
import 'package:ecommerce/domain/entities/request/register_request_dto.dart';

extension RegisterMapper on RegisterRequestDto {
  RegisterRequest toRegisterRequest() {
    return RegisterRequest(
      name: name,
      email: email,
      password: password,
      rePassword: rePassword,
      phone: phone,
    );
  }
}
