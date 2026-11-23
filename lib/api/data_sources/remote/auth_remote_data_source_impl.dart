import 'package:dio/dio.dart';
import 'package:ecommerce/api/mapper/auth_response_mapper.dart';
import 'package:ecommerce/api/mapper/login_req_dto_mapper.dart';
import 'package:ecommerce/api/mapper/register_mapper.dart';
import 'package:ecommerce/api/web_services.dart';
import 'package:ecommerce/core/exceptions/dio_exception_mapper.dart';
import 'package:ecommerce/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:ecommerce/domain/entities/request/login_request_dto.dart';
import 'package:ecommerce/domain/entities/request/register_request_dto.dart';
import 'package:ecommerce/domain/entities/response/auth_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  WebServices webServices;
  AuthRemoteDataSourceImpl({required this.webServices});
  @override
  Future<AuthResponseDto> login(LoginRequestDto loginReq) async {
    try {
      var response = await webServices.logIn(loginReq.toLoginRequest());
      return response.toAuthResponseDto();
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<AuthResponseDto> register(RegisterRequestDto regReq) async {
    try {
      var response = await webServices.register(regReq.toRegisterRequest());
      return response.toAuthResponseDto();
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}
