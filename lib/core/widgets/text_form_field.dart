import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String? value)? validator;
  final bool? obscureText;

  final Widget? suffixIcon, prefixIcon;
  const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,

      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.white,

        contentPadding: const .symmetric(vertical: 10, horizontal: 20),
        floatingLabelBehavior: FloatingLabelBehavior.auto,

        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.borderColor, width: 1),
        ),
        labelStyle: AppTextStyles.font14SecondSans,
        floatingLabelStyle: AppTextStyles.font12SecondSans500,
        suffixIcon: suffixIcon,
        suffixIconColor: AppColors.mainColor,
      ),

      style: AppTextStyles.font16MainSans,
    );
  }
}
