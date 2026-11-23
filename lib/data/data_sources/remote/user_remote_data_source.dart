import 'package:ecommerce/domain/entities/request/address_request.dart';
import 'package:ecommerce/domain/entities/request/change_password_request.dart';
import 'package:ecommerce/domain/entities/request/update_profile_request.dart';
import 'package:ecommerce/domain/entities/response/address.dart';
import 'package:ecommerce/domain/entities/response/user_profile.dart';

abstract class UserRemoteDataSource {
  Future<UserProfile> updateProfile(UpdateProfileRequest request);

  /// Returns the new session token issued by the backend, if any.
  Future<String?> changePassword(ChangePasswordRequest request);
  Future<List<Address>> getAddresses();
  Future<List<Address>> addAddress(AddressRequest request);
}
