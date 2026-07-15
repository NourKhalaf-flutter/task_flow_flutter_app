import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class ButtonSecondryWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String content;
  const ButtonSecondryWidget({
    super.key,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.borderColor.withAlpha(38),
        border: .all(color: AppColors.secondColor),
      ),
      child: TextButton(
        onPressed: onPressed,

        child: Text(
          content.toUpperCase(),
          style: AppTextStyles.font14MainSans700,
        ),
      ),
    );
  }
}
