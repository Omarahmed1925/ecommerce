import 'package:ecommerce/domain/entities/request/address_request.dart';
import 'package:ecommerce/domain/entities/response/address.dart';
import 'package:ecommerce/domain/repos/user_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddAddressUseCase {
  final UserRepo userRepo;

  AddAddressUseCase({required this.userRepo});

  Future<List<Address>> invoke(AddressRequest request) =>
      userRepo.addAddress(request);
}
