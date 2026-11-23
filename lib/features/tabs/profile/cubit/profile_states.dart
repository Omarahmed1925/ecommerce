import 'package:ecommerce/domain/entities/response/address.dart';
import 'package:ecommerce/domain/entities/response/user_profile.dart';

sealed class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {
  final UserProfile profile;

  /// `null` while addresses are loading.
  final List<Address>? addresses;
  final String? addressesError;
  final bool isSubmitting;

  ProfileSuccessState({
    required this.profile,
    this.addresses,
    this.addressesError,
    this.isSubmitting = false,
  });

  Address? get primaryAddress =>
      (addresses?.isNotEmpty ?? false) ? addresses!.first : null;
}

/// One-off effects (toasts, navigation); never rendered by builders.
sealed class ProfileActionState extends ProfileStates {}

class ProfileActionSuccessState extends ProfileActionState {
  final String message;
  ProfileActionSuccessState({required this.message});
}

class ProfileActionErrorState extends ProfileActionState {
  final String message;
  ProfileActionErrorState({required this.message});
}

class ProfileLoggedOutState extends ProfileActionState {}
