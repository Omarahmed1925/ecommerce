import 'package:ecommerce/domain/entities/request/register_request_dto.dart';
import 'package:ecommerce/domain/entities/response/auth_response_dto.dart';
import 'package:ecommerce/domain/repos/auth_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUseCase {
  AuthRepository authRepository;
  RegisterUseCase({required this.authRepository});
  Future<AuthResponseDto> invoke(RegisterRequestDto registerReq) async {
    return await authRepository.register(registerReq);
  }
}
