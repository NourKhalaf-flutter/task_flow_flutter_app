import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_colors.dart';

class AmbientGlowBackground extends StatelessWidget {
  final Widget child;

  const AmbientGlowBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: AppColors.scaffoldBackground,
        child: child,
      ),
    );
  }
}
