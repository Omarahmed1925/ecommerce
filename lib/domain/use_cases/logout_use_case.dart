import 'package:ecommerce/domain/repos/user_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase {
  final UserRepo userRepo;

  LogoutUseCase({required this.userRepo});

  Future<void> invoke() => userRepo.logout();
}
