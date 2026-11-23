import 'package:ecommerce/domain/entities/response/address.dart';
import 'package:ecommerce/domain/repos/user_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAddressesUseCase {
  final UserRepo userRepo;

  GetAddressesUseCase({required this.userRepo});

  Future<List<Address>> invoke() => userRepo.getAddresses();
}
