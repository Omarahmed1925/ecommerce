import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/domain/entities/request/address_request.dart';
import 'package:ecommerce/domain/entities/request/change_password_request.dart';
import 'package:ecommerce/domain/entities/request/update_profile_request.dart';
import 'package:ecommerce/domain/entities/response/address.dart';
import 'package:ecommerce/domain/entities/response/user_profile.dart';
import 'package:ecommerce/domain/use_cases/add_address_use_case.dart';
import 'package:ecommerce/domain/use_cases/change_password_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_addresses_use_case.dart';
import 'package:ecommerce/domain/use_cases/get_cached_profile_use_case.dart';
import 'package:ecommerce/domain/use_cases/logout_use_case.dart';
import 'package:ecommerce/domain/use_cases/update_profile_use_case.dart';
import 'package:ecommerce/features/tabs/profile/cubit/profile_states.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProfileViewModel extends Cubit<ProfileStates> {
  final GetCachedProfileUseCase getCachedProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileViewModel({
    required this.getCachedProfileUseCase,
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
    required this.getAddressesUseCase,
    required this.addAddressUseCase,
    required this.logoutUseCase,
  }) : super(ProfileInitialState());

  UserProfile _profile = UserProfile();
  List<Address>? _addresses;
  String? _addressesError;

  Future<void> loadProfile() async {
    _profile = getCachedProfileUseCase.invoke();
    _addresses = null;
    _addressesError = null;
    _emitProfile();
    try {
      _addresses = await getAddressesUseCase.invoke();
    } on AppExceptions catch (e) {
      _addressesError = e.message;
    }
    _emitProfile();
  }

  Future<void> updateName(String name) =>
      _updateProfile(UpdateProfileRequest(name: name), 'Name updated');

  Future<void> updateEmail(String email) =>
      _updateProfile(UpdateProfileRequest(email: email), 'E-mail updated');

  Future<void> updatePhone(String phone) =>
      _updateProfile(UpdateProfileRequest(phone: phone), 'Mobile updated');

  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String rePassword,
  }) {
    return _submit(() async {
      await changePasswordUseCase.invoke(
        ChangePasswordRequest(
          currentPassword: currentPassword,
          password: password,
          rePassword: rePassword,
        ),
      );
      return 'Password changed';
    });
  }

  Future<void> addAddress(AddressRequest request) {
    return _submit(() async {
      _addresses = await addAddressUseCase.invoke(request);
      _addressesError = null;
      return 'Address saved';
    });
  }

  Future<void> logout() async {
    await logoutUseCase.invoke();
    emit(ProfileLoggedOutState());
  }

  Future<void> _updateProfile(UpdateProfileRequest request, String message) {
    return _submit(() async {
      _profile = await updateProfileUseCase.invoke(request);
      return message;
    });
  }

  Future<void> _submit(Future<String> Function() action) async {
    _emitProfile(isSubmitting: true);
    try {
      final message = await action();
      emit(ProfileActionSuccessState(message: message));
    } on AppExceptions catch (e) {
      emit(ProfileActionErrorState(message: e.message));
    }
    _emitProfile();
  }

  void _emitProfile({bool isSubmitting = false}) {
    emit(
      ProfileSuccessState(
        profile: _profile,
        addresses: _addresses,
        addressesError: _addressesError,
        isSubmitting: isSubmitting,
      ),
    );
  }
}
