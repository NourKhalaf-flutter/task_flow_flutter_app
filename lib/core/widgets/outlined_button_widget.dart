import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OutlinedButtonWidget extends StatelessWidget {
  final String? leading, trailing;
  final Widget? trailingWidget;
  final String title;
  final onTapped;
  const OutlinedButtonWidget(
    this.title,
    this.onTapped, {
    this.leading,
    this.trailing,
    this.trailingWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Container(
        width: .infinity,
        margin: const EdgeInsets.only(left: 20, bottom: 10),
        padding: const .symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          border: .all(color: AppColors.borderColor),
          borderRadius: const .only(
            topLeft: Radius.circular(5),
            bottomLeft: Radius.circular(5),
          ),
        ),
        child: Row(
          children: [
            if (leading != null) SvgPicture.asset(leading!),
            const SizedBox(width: 10),
            Text(title, style: AppTextStyles.font16MainSans),
            const Spacer(),
            if (trailingWidget != null) trailingWidget!,
            if (trailing != null) SvgPicture.asset(trailing!),
          ],
        ),
      ),
    );
  }
}
