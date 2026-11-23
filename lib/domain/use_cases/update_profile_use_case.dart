import 'package:ecommerce/domain/entities/request/update_profile_request.dart';
import 'package:ecommerce/domain/entities/response/user_profile.dart';
import 'package:ecommerce/domain/repos/user_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileUseCase {
  final UserRepo userRepo;

  UpdateProfileUseCase({required this.userRepo});

  Future<UserProfile> invoke(UpdateProfileRequest request) =>
      userRepo.updateProfile(request);
}
