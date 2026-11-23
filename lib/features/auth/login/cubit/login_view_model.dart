import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/domain/entities/request/login_request_dto.dart';
import 'package:ecommerce/domain/use_cases/login_use_case.dart';
import 'package:ecommerce/features/auth/login/cubit/auth_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel extends Cubit<AuthState> {
  LoginUseCase loginUseCase;

  LoginViewModel({required this.loginUseCase}) : super(AuthInitial());
  final formKey = GlobalKey<FormState>();

  void login(String email, String password) async {
    try {
      if (formKey.currentState!.validate()) {
        emit(AuthLoading());
        var loginReq = LoginRequestDto(email: email, password: password);
        var response = await loginUseCase.invoke(loginReq);
        emit(AuthSuccess(authResponse: response));
      }
    } on AppExceptions catch (e) {
      // Network errors are translated to AppExceptions in the data source.
      emit(AuthFailure(e.message));
    }
  }
}
