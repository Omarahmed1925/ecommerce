import 'package:ecommerce/domain/entities/request/change_password_request.dart';
import 'package:ecommerce/domain/repos/user_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final UserRepo userRepo;

  ChangePasswordUseCase({required this.userRepo});

  Future<void> invoke(ChangePasswordRequest request) =>
      userRepo.changePassword(request);
}
