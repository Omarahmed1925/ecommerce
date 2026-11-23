import 'package:dio/dio.dart';
import 'package:ecommerce/api/mapper/address_mapper.dart';
import 'package:ecommerce/api/mapper/user_profile_mapper.dart';
import 'package:ecommerce/api/web_services.dart';
import 'package:ecommerce/core/exceptions/dio_exception_mapper.dart';
import 'package:ecommerce/data/data_sources/remote/user_remote_data_source.dart';
import 'package:ecommerce/domain/entities/request/address_request.dart';
import 'package:ecommerce/domain/entities/request/change_password_request.dart';
import 'package:ecommerce/domain/entities/request/update_profile_request.dart';
import 'package:ecommerce/domain/entities/response/address.dart';
import 'package:ecommerce/domain/entities/response/user_profile.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final WebServices webServices;

  UserRemoteDataSourceImpl({required this.webServices});

  @override
  Future<UserProfile> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await webServices.updateMe(
        request.toUpdateMeRequestDto(),
      );
      return response.user?.toUserProfile() ?? UserProfile();
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<String?> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await webServices.changePassword(
        request.toChangePasswordRequestDto(),
      );
      return response.token;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<Address>> getAddresses() async {
    try {
      final response = await webServices.getAddresses();
      return response.data?.map((dto) => dto.toAddress()).toList() ?? [];
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<Address>> addAddress(AddressRequest request) async {
    try {
      final response = await webServices.addAddress(
        request.toAddressRequestDto(),
      );
      return response.data?.map((dto) => dto.toAddress()).toList() ?? [];
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}
