import 'package:ecommerce/domain/entities/response/auth_response_dto.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  AuthResponseDto authResponse;
  AuthSuccess({required this.authResponse});
}

class AuthFailure extends AuthState {
  String errorMessage;
  AuthFailure(this.errorMessage);
}
