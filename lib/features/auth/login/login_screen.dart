import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:ecommerce/widgets/responsive_center.dart';
import 'package:ecommerce/config/di/di.dart';
import 'package:ecommerce/core/utils/app_assets.dart';
import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/core/utils/cache.dart';
import 'package:ecommerce/core/utils/diaolg_utils.dart';
import 'package:ecommerce/features/auth/login/cubit/auth_states.dart';
import 'package:ecommerce/features/auth/login/cubit/login_view_model.dart';
import 'package:ecommerce/widgets/custom_elevated_button.dart';
import 'package:ecommerce/widgets/custom_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/app_colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController emailController = TextEditingController(
    text: "oa718307@gmail.com",
  );
  TextEditingController passwordController = TextEditingController(
    text: "omar@123",
  );
  LoginViewModel loginViewModel = getIt<LoginViewModel>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginViewModel, AuthState>(
      bloc: loginViewModel,
      listener: (context, state) {
        if (state is AuthLoading) {
          DialogUtils.showLoadingDialog(context);
        } else if (state is AuthFailure) {
          DialogUtils.hideLoadingDialog(context);
          DialogUtils.showMessageDiaolog(
            context: context,
            message: state.errorMessage,
            title: "error",
            postActionName: "ok",
          );
        } else if (state is AuthSuccess) {
          DialogUtils.hideLoadingDialog(context);
          SharedPreferencesUtils.saveData(
            key: 'token',
            value: state.authResponse.token,
          );
          DialogUtils.showMessageDiaolog(
            context: context,
            message: "Login Success",
            postActionName: "ok",
            title: "Login Success",
            postActionFunction: () {
              Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SafeArea(
          child: ResponsiveCenter(
            maxWidth: AppLayout.formMaxWidth,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(
                  key: loginViewModel.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(AppAssets.routeLogo),
                      SizedBox(height: 87.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Welcome Back To Route\n",
                              style: AppStyles.semi24White,
                            ),
                            TextSpan(
                              text: "Please sign in with your mail",
                              style: AppStyles.light16White,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Text("User Name", style: AppStyles.medium18White),
                      SizedBox(height: 24.h),
                      CustomTextFormField(
                        hintText: "Enter your name",
                        controller: emailController,
                      ),
                      SizedBox(height: 32.h),
                      Text("Password", style: AppStyles.medium18White),
                      SizedBox(height: 24.h),
                      CustomTextFormField(
                        hintText: "enter your password",
                        controller: passwordController,
                        isObsecure: true,
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: AppColors.grayColor,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Forgot Password?",
                            style: AppStyles.regular16White,
                          ),
                        ],
                      ),
                      SizedBox(height: 56.h),
                      Customelevatedbutton(
                        onPressed: () {
                          loginViewModel.login(
                            emailController.text,
                            passwordController.text,
                          );
                        },
                        text: "Login",
                        borderSideColor: AppColors.whiteColor,
                        textStyle: AppStyles.semi20Primary,
                      ),
                      SizedBox(height: 32.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.registerScreen,
                          );
                        },
                        child: Text(
                          "Don't have an account? Create Account",
                          style: AppStyles.medium18White,
                          textAlign: TextAlign.center,
                        ),
                      ),
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
