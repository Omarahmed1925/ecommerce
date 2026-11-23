import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/domain/entities/request/register_request_dto.dart';
import 'package:ecommerce/domain/use_cases/register_use_case.dart';
import 'package:ecommerce/features/auth/login/cubit/auth_states.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterViewModel extends Cubit<AuthState> {
  final RegisterUseCase registerUseCase;

  RegisterViewModel({required this.registerUseCase}) : super(AuthInitial());

  final formKey = GlobalKey<FormState>();

  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    if (formKey.currentState?.validate() != true) return;
    emit(AuthLoading());
    try {
      final response = await registerUseCase.invoke(
        RegisterRequestDto(
          name: name.trim(),
          phone: phone.trim(),
          email: email.trim(),
          password: password,
          // The design has a single password field; the API requires both.
          rePassword: password,
        ),
      );
      emit(AuthSuccess(authResponse: response));
    } on AppExceptions catch (e) {
      emit(AuthFailure(e.message));
    }
  }
}
