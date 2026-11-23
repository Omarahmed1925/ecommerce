import 'package:flutter/material.dart';

import '../../../../core/utils/app_textstyles.dart';

class LineBreak extends StatelessWidget {
  final String text;
  final VoidCallback? onViewAll;

  const LineBreak({super.key, required this.text, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: AppStyles.medium18Header),
        const Spacer(),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text('view all', style: AppStyles.regular12Primary),
          ),
      ],
    );
  }
}
