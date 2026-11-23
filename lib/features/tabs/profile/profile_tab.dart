import 'package:ecommerce/core/utils/app_layout.dart';
import 'package:ecommerce/widgets/responsive_center.dart';
import 'package:ecommerce/config/di/di.dart';
import 'package:ecommerce/core/utils/app_assets.dart';
import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/core/utils/toast_utils.dart';
import 'package:ecommerce/core/utils/validation.dart';
import 'package:ecommerce/domain/entities/request/address_request.dart';
import 'package:ecommerce/features/tabs/cart_tab/cubit/cart_view_model.dart';
import 'package:ecommerce/features/tabs/fav_tab/cubit/wishlist_view_model.dart';
import 'package:ecommerce/features/tabs/profile/cubit/profile_states.dart';
import 'package:ecommerce/features/tabs/profile/cubit/profile_view_model.dart';
import 'package:ecommerce/features/tabs/profile/widgets/profile_edit_dialog.dart';
import 'package:ecommerce/features/tabs/profile/widgets/profile_field_item.dart';
import 'package:ecommerce/widgets/main_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final ProfileViewModel viewModel = getIt<ProfileViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.loadProfile();
  }

  @override
  void dispose() {
    viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Image.asset(AppAssets.routeSmallLogo),
      ),
      body: BlocConsumer<ProfileViewModel, ProfileStates>(
        bloc: viewModel,
        listenWhen: (previous, current) => current is ProfileActionState,
        listener: _onAction,
        buildWhen: (previous, current) => current is! ProfileActionState,
        builder: (context, state) => state is ProfileSuccessState
            ? ResponsiveCenter(
                maxWidth: AppLayout.formMaxWidth + 120,
                child: _buildContent(state),
              )
            : const MainLoading(),
      ),
    );
  }

  void _onAction(BuildContext context, ProfileStates state) {
    switch (state) {
      case ProfileActionSuccessState():
        ToastUtils.toast(
          msg: state.message,
          bgColor: AppColors.greenColor,
          txtColor: AppColors.whiteColor,
        );
      case ProfileActionErrorState():
        ToastUtils.toast(
          msg: state.message,
          bgColor: AppColors.redColor,
          txtColor: AppColors.whiteColor,
        );
      case ProfileLoggedOutState():
        context.read<CartViewModel>().reset();
        context.read<WishlistViewModel>().reset();
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.loginScreen, (route) => false);
      default:
        break;
    }
  }

  Widget _buildContent(ProfileSuccessState state) {
    final profile = state.profile;
    final enabled = !state.isSubmitting;
    return Column(
      children: [
        if (state.isSubmitting)
          const LinearProgressIndicator(color: AppColors.primaryColor),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            children: [
              Text(
                'Welcome, ${profile.name ?? ''}',
                style: AppStyles.semi18Primary,
              ),
              Text(profile.email ?? '', style: AppStyles.regular14Gray),
              SizedBox(height: 32.h),
              ProfileFieldItem(
                label: 'Your full name',
                value: profile.name ?? '',
                onEdit: enabled ? () => _editName(profile.name) : null,
              ),
              SizedBox(height: 20.h),
              ProfileFieldItem(
                label: 'Your E-mail',
                value: profile.email ?? '',
                onEdit: enabled ? () => _editEmail(profile.email) : null,
              ),
              SizedBox(height: 20.h),
              ProfileFieldItem(
                label: 'Your password',
                value: '••••••••••••',
                onEdit: enabled ? _editPassword : null,
              ),
              SizedBox(height: 20.h),
              ProfileFieldItem(
                label: 'Your mobile number',
                value: profile.phone ?? 'Not set',
                onEdit: enabled ? () => _editPhone(profile.phone) : null,
              ),
              SizedBox(height: 20.h),
              ProfileFieldItem(
                label: 'Your Address',
                value: _addressText(state),
                onEdit: enabled ? _addAddress : null,
              ),
              SizedBox(height: 32.h),
              OutlinedButton.icon(
                onPressed: enabled ? viewModel.logout : null,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.redColor),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                icon: const Icon(Icons.logout, color: AppColors.redColor),
                label: Text(
                  'Logout',
                  style: AppStyles.medium16Primary.copyWith(
                    color: AppColors.redColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _addressText(ProfileSuccessState state) {
    if (state.addresses == null && state.addressesError == null) {
      return 'Loading…';
    }
    if (state.addressesError != null) return state.addressesError!;
    final address = state.primaryAddress;
    if (address == null) return 'No address yet — tap edit to add one';
    return [
      address.details,
      address.city,
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
  }

  void _editName(String? current) {
    ProfileEditDialog.show(
      context,
      title: 'Edit full name',
      fields: [
        ProfileEditField(
          hint: 'Full name',
          initialValue: current ?? '',
          validator: AppValidator.validateName,
        ),
      ],
      onSubmit: (values) => viewModel.updateName(values[0]),
    );
  }

  void _editEmail(String? current) {
    ProfileEditDialog.show(
      context,
      title: 'Edit E-mail',
      fields: [
        ProfileEditField(
          hint: 'E-mail',
          initialValue: current ?? '',
          validator: AppValidator.validateEmail,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
      onSubmit: (values) => viewModel.updateEmail(values[0]),
    );
  }

  void _editPhone(String? current) {
    ProfileEditDialog.show(
      context,
      title: 'Edit mobile number',
      fields: [
        ProfileEditField(
          hint: 'Mobile number',
          initialValue: current ?? '',
          validator: AppValidator.validatePhone,
          keyboardType: TextInputType.phone,
        ),
      ],
      onSubmit: (values) => viewModel.updatePhone(values[0]),
    );
  }

  void _editPassword() {
    String newPassword = '';
    ProfileEditDialog.show(
      context,
      title: 'Change password',
      fields: [
        ProfileEditField(
          hint: 'Current password',
          obscure: true,
          validator: (v) =>
              (v == null || v.isEmpty) ? "Password can't be empty" : null,
        ),
        ProfileEditField(
          hint: 'New password',
          obscure: true,
          validator: (v) {
            newPassword = v ?? '';
            return AppValidator.validatePassword(v);
          },
        ),
        ProfileEditField(
          hint: 'Confirm new password',
          obscure: true,
          validator: (v) => AppValidator.validateRePassword(v, newPassword),
        ),
      ],
      onSubmit: (values) => viewModel.changePassword(
        currentPassword: values[0],
        password: values[1],
        rePassword: values[2],
      ),
    );
  }

  void _addAddress() {
    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? "This field can't be empty" : null;
    ProfileEditDialog.show(
      context,
      title: 'Add address',
      fields: [
        ProfileEditField(
          hint: 'Label (e.g. Home)',
          initialValue: 'Home',
          validator: required,
        ),
        ProfileEditField(hint: 'Address details', validator: required),
        ProfileEditField(hint: 'City', validator: required),
        ProfileEditField(
          hint: 'Phone',
          validator: AppValidator.validatePhone,
          keyboardType: TextInputType.phone,
        ),
      ],
      onSubmit: (values) => viewModel.addAddress(
        AddressRequest(
          name: values[0],
          details: values[1],
          city: values[2],
          phone: values[3],
        ),
      ),
    );
  }
}
