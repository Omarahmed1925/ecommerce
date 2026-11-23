import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/utils/app_colors.dart';

typedef validatorFunction = String? Function(String?)?;

class CustomTextFormField extends StatelessWidget {
  String? hintText;
  String? labelText;
  Widget? prefixIcon;
  Widget? suffixIcon;
  Color? borderColor = AppColors.whiteColor;
  validatorFunction validator;
  double? borderRadius;
  bool? isObsecure;
  int? maxLines;
  TextEditingController controller;
  TextInputAction? textInputAction;
  TextInputType? keyboardType;
  ValueChanged<String>? onFieldSubmitted;

  CustomTextFormField({
    super.key,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    required this.controller,
    this.maxLines = 1,
    this.validator,
    this.isObsecure = false,
    this.borderColor,
    this.borderRadius = 16,
    this.textInputAction,
    this.keyboardType,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          enabledBorder: buildBorder(borderColor ?? AppColors.whiteColor),
          focusedBorder: buildBorder(borderColor ?? AppColors.whiteColor),
          errorBorder: buildBorder(AppColors.redColor),
          focusedErrorBorder: buildBorder(AppColors.redColor),
          hintText: hintText ?? "",
          hintStyle: AppStyles.light18grey,
          fillColor: AppColors.whiteColor,
          labelText: labelText,
          labelStyle: AppStyles.light18grey,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        controller: controller,
        maxLines: maxLines ?? 1,
        validator: validator,
        obscureText: isObsecure ?? false,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }

  OutlineInputBorder buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 16),
      borderSide: BorderSide(color: color, width: 2),
    );
  }
}
