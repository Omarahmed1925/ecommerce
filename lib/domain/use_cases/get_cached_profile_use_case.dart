import 'package:ecommerce/domain/entities/response/user_profile.dart';
import 'package:ecommerce/domain/repos/user_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCachedProfileUseCase {
  final UserRepo userRepo;

  GetCachedProfileUseCase({required this.userRepo});

  UserProfile invoke() => userRepo.getCachedProfile();
}
