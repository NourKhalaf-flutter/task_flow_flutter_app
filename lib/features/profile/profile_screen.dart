import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_images.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
 import 'package:task_flow/features/auth/login_provider.dart';

import '../outlined_button_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<LoginProvider>();

    return SingleChildScrollView(
      child: Padding(
        padding: const .only(top: 50, bottom: 20),
        child: Column(
          children: [
            ListTile(
              contentPadding: const .symmetric(horizontal: 20),
              minLeadingWidth: 60,

              title: Text(
                auth.currentUser?.name ?? '',
                style: AppTextStyles.font14MainInter600,
              ),
              subtitle: Text(
                auth.currentUser?.email ?? '',

                style: AppTextStyles.font14SecondSans,
              ),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.greylight,
                child: Text(
                   auth.currentUser?.name[0].toUpperCase() ?? 'U',
                  
                  style: AppTextStyles.font18MainInter500,
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const EditNameSheet(),
                  );
                },
                borderRadius: .circular(20),
                child: Container(
                  padding: const .all(12),
                  child: SvgPicture.asset(AppSvgs.edit),
                ),
              ),
            ),
            const SizedBox(height: 30),
            OutlinedButtonWidget(
              'My orders',
              () {},
              leading: AppSvgs.order,
              trailing: AppSvgs.arrowRight,
            ),
            OutlinedButtonWidget(
              'Payment method',
              () {},
              leading: AppSvgs.payment,
              trailing: AppSvgs.arrowRight,
            ),
            OutlinedButtonWidget(
              'Delivery address',
              () {},
              leading: AppSvgs.map,
              trailing: AppSvgs.arrowRight,
            ),
            OutlinedButtonWidget(
              'Promocodes & gift cards',
              () {},
              leading: AppSvgs.gift,
              trailing: AppSvgs.arrowRight,
            ),
            OutlinedButtonWidget('Sign out', () async {
              await context.read<LoginProvider>().logout();
              // Navigator.pushNamedAndRemoveUntil(
              //   context,
              //   RouteNames.loginScreen,
              //   (route) => false,
              // );
            }, leading: AppSvgs.logout),
          ],
        ),
      ),
    );
  }
}

class EditNameSheet extends StatefulWidget {
  const EditNameSheet({super.key});

  @override
  State<EditNameSheet> createState() => _EditNameSheetState();
}

class _EditNameSheetState extends State<EditNameSheet> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(
      text: context.read<LoginProvider>().currentUser?.name ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Edit name', style: AppTextStyles.font18MainInter500),

          const SizedBox(height: 20),

          TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Name'),
          ),

          const SizedBox(height: 20),

          OutlinedButton(
            onPressed: () async {
              final name = controller.text.trim();

              if (name.isEmpty) return;

              await context.read<LoginProvider>().updateName(name);

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
