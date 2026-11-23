import 'package:ecommerce/api/model/request/login_request.dart';
import 'package:ecommerce/domain/entities/request/login_request_dto.dart';

extension LoginReqDtoMapper on LoginRequestDto {
  LoginRequest toLoginRequest() {
    return LoginRequest(email: this.email, password: this.password);
  }
}
