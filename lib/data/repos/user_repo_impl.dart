import 'package:ecommerce/data/data_sources/local/user_local_data_source.dart';
import 'package:ecommerce/data/data_sources/remote/user_remote_data_source.dart';
import 'package:ecommerce/domain/entities/request/address_request.dart';
import 'package:ecommerce/domain/entities/request/change_password_request.dart';
import 'package:ecommerce/domain/entities/request/update_profile_request.dart';
import 'package:ecommerce/domain/entities/response/address.dart';
import 'package:ecommerce/domain/entities/response/user_profile.dart';
import 'package:ecommerce/domain/repos/user_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRepo)
class UserRepoImpl implements UserRepo {
  final UserRemoteDataSource userRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;

  UserRepoImpl({
    required this.userRemoteDataSource,
    required this.userLocalDataSource,
  });

  @override
  UserProfile getCachedProfile() => userLocalDataSource.getProfile();

  @override
  Future<UserProfile> updateProfile(UpdateProfileRequest request) async {
    final remote = await userRemoteDataSource.updateProfile(request);
    final cached = userLocalDataSource.getProfile();
    // The updateMe response returns name/email only, so the phone sent is kept.
    final merged = UserProfile(
      name: remote.name ?? request.name ?? cached.name,
      email: remote.email ?? request.email ?? cached.email,
      phone: request.phone ?? cached.phone,
    );
    await userLocalDataSource.saveProfile(merged);
    return merged;
  }

  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    final newToken = await userRemoteDataSource.changePassword(request);
    if (newToken != null && newToken.isNotEmpty) {
      await userLocalDataSource.saveToken(newToken);
    }
  }

  @override
  Future<List<Address>> getAddresses() => userRemoteDataSource.getAddresses();

  @override
  Future<List<Address>> addAddress(AddressRequest request) =>
      userRemoteDataSource.addAddress(request);

  @override
  Future<void> logout() => userLocalDataSource.clear();
}
