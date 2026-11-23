import 'package:ecommerce/api/model/request/change_password_request_dto.dart';
import 'package:ecommerce/api/model/request/update_me_request_dto.dart';
import 'package:ecommerce/api/model/response/user.dart';
import 'package:ecommerce/domain/entities/request/change_password_request.dart';
import 'package:ecommerce/domain/entities/request/update_profile_request.dart';
import 'package:ecommerce/domain/entities/response/user_profile.dart';

extension UserProfileMapper on User {
  UserProfile toUserProfile() => UserProfile(name: name, email: email);
}

extension UpdateProfileRequestMapper on UpdateProfileRequest {
  UpdateMeRequestDto toUpdateMeRequestDto() =>
      UpdateMeRequestDto(name: name, email: email, phone: phone);
}

extension ChangePasswordRequestMapper on ChangePasswordRequest {
  ChangePasswordRequestDto toChangePasswordRequestDto() =>
      ChangePasswordRequestDto(
        currentPassword: currentPassword,
        password: password,
        rePassword: rePassword,
      );
}
