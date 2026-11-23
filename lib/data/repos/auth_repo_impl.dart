import 'package:ecommerce/data/data_sources/local/user_local_data_source.dart';
import 'package:ecommerce/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:ecommerce/domain/entities/request/login_request_dto.dart';
import 'package:ecommerce/domain/entities/request/register_request_dto.dart';
import 'package:ecommerce/domain/entities/response/auth_response_dto.dart';
import 'package:ecommerce/domain/entities/response/user_profile.dart';
import 'package:ecommerce/domain/repos/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepoImpl implements AuthRepository {
  AuthRemoteDataSource authRemoteDataSource;
  UserLocalDataSource userLocalDataSource;

  AuthRepoImpl({
    required this.authRemoteDataSource,
    required this.userLocalDataSource,
  });

  @override
  Future<AuthResponseDto> login(LoginRequestDto loginReq) async {
    final response = await authRemoteDataSource.login(loginReq);
    await _cacheUser(response);
    return response;
  }

  @override
  Future<AuthResponseDto> register(RegisterRequestDto regReq) async {
    final response = await authRemoteDataSource.register(regReq);
    await _cacheUser(response, phone: regReq.phone);
    return response;
  }

  /// Cached so the Account screen can show who is signed in; the backend
  /// collection has no "get my profile" endpoint.
  Future<void> _cacheUser(AuthResponseDto response, {String? phone}) {
    return userLocalDataSource.saveProfile(
      UserProfile(
        name: response.user?.name,
        email: response.user?.email,
        phone: phone,
      ),
    );
  }
}
