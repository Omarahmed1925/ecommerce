import 'package:ecommerce/core/utils/app_textstyles.dart';

import 'package:flutter/material.dart';

import 'app_colors.dart';

class DialogUtils {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          content: Row(
            children: [
              const SizedBox(width: 20),
              CircularProgressIndicator(color: AppColors.primaryColor),
              const SizedBox(width: 20),
              Text('Loading...', style: AppStyles.regular16White),
            ],
          ),
        );
      },
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessageDiaolog({
    required BuildContext context,
    String? title,
    required String message,
    String? postActionName,
    Function? postActionFunction,
    String? negActionName,
    Function? negActionFunction,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        List<Widget> actions = [];
        if (postActionName != null) {
          actions.add(
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                postActionFunction?.call();
              },
              child: Text(
                postActionName,
                style: AppStyles.medium14LightPrimary,
              ),
            ),
          );
        }
        if (negActionName != null) {
          actions.add(
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                negActionFunction?.call();
              },
              child: Text(negActionName, style: AppStyles.medium14LightPrimary),
            ),
          );
        }
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          title: Text(title ?? " ", style: AppStyles.medium14LightPrimary),
          content: Text(message, style: AppStyles.medium14PrimaryDark),
          actions: actions,
        );
      },
    );
  }
}
