import 'package:ecommerce/config/di/di.dart';
import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/core/utils/cache.dart';
import 'package:ecommerce/core/utils/diaolg_utils.dart';
import 'package:ecommerce/core/utils/validation.dart';
import 'package:ecommerce/features/auth/login/cubit/auth_states.dart';
import 'package:ecommerce/features/auth/register/cubit/register_screen_view_model.dart';
import 'package:ecommerce/widgets/responsive_center.dart';
import 'package:ecommerce/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_textstyles.dart';
import '../../../widgets/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterViewModel viewModel = getIt<RegisterViewModel>();

  // One controller per field, owned by State so typed text survives rebuilds
  // (e.g. folding/unfolding) and the controllers are disposed.
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    viewModel.close();
    super.dispose();
  }

  void _signUp() {
    viewModel.register(
      name: fullNameController.text,
      phone: phoneController.text,
      email: emailController.text,
      password: passwordController.text,
    );
  }

  void _onStateChanged(BuildContext context, AuthState state) {
    switch (state) {
      case AuthLoading():
        DialogUtils.showLoadingDialog(context);
      case AuthFailure():
        DialogUtils.hideLoadingDialog(context);
        DialogUtils.showMessageDiaolog(
          context: context,
          title: 'error',
          message: state.errorMessage,
          postActionName: 'ok',
        );
      case AuthSuccess():
        DialogUtils.hideLoadingDialog(context);
        // Same session handling as the login screen.
        SharedPreferencesUtils.saveData(
          key: CacheKeys.token,
          value: state.authResponse.token,
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.homeScreen,
          (route) => false,
        );
      case AuthInitial():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterViewModel, AuthState>(
      bloc: viewModel,
      listener: _onStateChanged,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          // Scrollable so it fits short windows (landscape, folded cover screen).
          child: ResponsiveCenter(
            maxWidth: AppLayout.formMaxWidth,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(AppAssets.routeLogo),
                      SizedBox(height: 30.h),
                      Text("Full Name", style: AppStyles.medium18White),
                      SizedBox(height: 24.h),
                      CustomTextFormField(
                        hintText: "Enter your name",
                        controller: fullNameController,
                        validator: AppValidator.validateName,
                      ),
                      SizedBox(height: 32.h),
                      Text("Mobile Number", style: AppStyles.medium18White),
                      SizedBox(height: 24.h),
                      CustomTextFormField(
                        hintText: "Enter your phone No.",
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: AppValidator.validatePhone,
                      ),
                      SizedBox(height: 32.h),
                      Text("Email address", style: AppStyles.medium18White),
                      SizedBox(height: 24.h),
                      CustomTextFormField(
                        hintText: "Enter your email address",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidator.validateEmail,
                      ),
                      SizedBox(height: 32.h),
                      Text("Password", style: AppStyles.medium18White),
                      SizedBox(height: 24.h),
                      CustomTextFormField(
                        hintText: "Enter your password",
                        controller: passwordController,
                        isObsecure: true,
                        validator: AppValidator.validatePassword,
                        suffixIcon: Icon(
                          Icons.visibility_off_outlined,
                          color: AppColors.grayColor,
                        ),
                      ),
                      SizedBox(height: 56.h),
                      Customelevatedbutton(onPressed: _signUp, text: 'Sign up'),
                      SizedBox(height: 24.h),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.loginScreen,
                        ),
                        child: Text(
                          'Already have an account? Login',
                          style: AppStyles.medium18White,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
