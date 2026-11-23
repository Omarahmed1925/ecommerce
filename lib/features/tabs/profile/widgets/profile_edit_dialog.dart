import 'package:ecommerce/core/utils/app_colors.dart';
import 'package:ecommerce/core/utils/app_textstyles.dart';
import 'package:ecommerce/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileEditField {
  final String hint;
  final String initialValue;
  final String? Function(String?)? validator;
  final bool obscure;
  final TextInputType? keyboardType;

  const ProfileEditField({
    required this.hint,
    this.initialValue = '',
    this.validator,
    this.obscure = false,
    this.keyboardType,
  });
}

/// Generic form dialog; calls [onSubmit] with the field values (in order)
/// once every validator passes.
class ProfileEditDialog extends StatefulWidget {
  final String title;
  final List<ProfileEditField> fields;
  final ValueChanged<List<String>> onSubmit;

  const ProfileEditDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<ProfileEditField> fields,
    required ValueChanged<List<String>> onSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (_) =>
          ProfileEditDialog(title: title, fields: fields, onSubmit: onSubmit),
    );
  }

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers = widget.fields
      .map((f) => TextEditingController(text: f.initialValue))
      .toList();

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    Navigator.pop(context);
    widget.onSubmit(_controllers.map((c) => c.text.trim()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.whiteColor,
      title: Text(widget.title, style: AppStyles.medium18Header),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < widget.fields.length; i++) ...[
                if (i > 0) SizedBox(height: 12.h),
                CustomTextFormField(
                  hintText: widget.fields[i].hint,
                  controller: _controllers[i],
                  validator: widget.fields[i].validator,
                  isObsecure: widget.fields[i].obscure,
                  keyboardType: widget.fields[i].keyboardType,
                  borderColor: AppColors.primary300pacity,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: AppStyles.medium14LightPrimary),
        ),
        TextButton(
          onPressed: _submit,
          child: Text('Save', style: AppStyles.medium14LightPrimary),
        ),
      ],
    );
  }
}
