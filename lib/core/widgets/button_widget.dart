import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String content;

  const ButtonWidget({
    super.key,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.mainColor, AppColors.black],
        ),
        borderRadius: .circular(5),
      ),
      height: 50,
      child: TextButton(
        onPressed: onPressed,

        child: Text(content, style: AppTextStyles.font14WhiteSans700),
      ),
    );
  }
}
