import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:task_flow/core/routes/route_names.dart';
import 'package:task_flow/core/widgets/button_widget.dart';
import 'package:task_flow/features/auth/login_provider.dart';
import 'package:task_flow/features/tasks/domain/entities/task.dart';
import 'package:task_flow/features/tasks/presentation/provider/tasks_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(18),
          border: AppColors.subtleCardBorder,
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.mainColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.secondColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
    Color? subtitleColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? AppColors.mainColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: subtitleColor ?? AppColors.secondColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of TaskFlow?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await context.read<LoginProvider>().logout();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.authWrapper,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<LoginProvider>();
    final taskProvider = context.watch<TasksProvider>();

    final tasks = taskProvider.tasks;
    final totalCount = tasks.length;
    final completedCount =
        tasks.where((t) => t.status == TaskStatus.completed).length;
    final pendingCount = totalCount - completedCount;
    final int completionRate =
        totalCount > 0 ? ((completedCount / totalCount) * 100).toInt() : 0;

    final userName = auth.currentUser?.name ?? 'User';
    final userEmail = auth.currentUser?.email ?? '';
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Profile',
          style: AppTextStyles.font18MainInter500.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // User Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: AppColors.subtleCardBorder,
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryAccent,
                                AppColors.violetAccent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryAccent
                                    .withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const EditNameSheet(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              size: 14,
                              color: AppColors.primaryAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.secondColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const EditNameSheet(),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greylight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 14,
                              color: AppColors.mainColor,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Edit Name',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Productivity Stats Row
              Row(
                children: [
                  _buildStatCard(
                    value: '$completedCount',
                    label: 'Completed',
                    icon: Icons.task_alt_rounded,
                    color: AppColors.mintAccent,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    value: '$pendingCount',
                    label: 'Pending',
                    icon: Icons.timelapse_rounded,
                    color: AppColors.primaryAccent,
                  ),
                  const SizedBox(width: 10),
                  _buildStatCard(
                    value: '$completionRate%',
                    label: 'Rate',
                    icon: Icons.trending_up_rounded,
                    color: const Color(0xFFF59E0B),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Settings & Preferences Group
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: AppColors.subtleCardBorder,
                  boxShadow: AppColors.softShadow,
                ),
                child: Column(
                  children: [
                    _buildSettingTile(
                      icon: Icons.notifications_none_rounded,
                      iconColor: AppColors.primaryAccent,
                      title: 'Task Reminders',
                      subtitle: 'Receive reminders for due tasks',
                      trailing: Switch.adaptive(
                        activeTrackColor: AppColors.primaryAccent,
                        value: _notificationsEnabled,
                        onChanged: (val) {
                          setState(() {
                            _notificationsEnabled = val;
                          });
                        },
                      ),
                    ),
                    const Divider(height: 1, indent: 60),
                    _buildSettingTile(
                      icon: Icons.folder_copy_outlined,
                      iconColor: const Color(0xFFF59E0B),
                      title: 'Manage Categories',
                      subtitle: 'Add or customize your task categories',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.manageCategoriesScreen,
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 60),
                    _buildSettingTile(
                      icon: Icons.info_outline_rounded,
                      iconColor: Colors.teal,
                      title: 'About TaskFlow',
                      subtitle: 'v1.0.0 • Modern Productivity App',
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'TaskFlow',
                          applicationVersion: '1.0.0',
                          applicationLegalese: 'Built with Flutter & Firebase',
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 60),
                    _buildSettingTile(
                      icon: Icons.logout_rounded,
                      iconColor: AppColors.red,
                      title: 'Sign Out',
                      titleColor: AppColors.red,
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.red.withValues(alpha: 0.6),
                      ),
                      onTap: () => _confirmSignOut(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        14,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Edit Name',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.mainColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Update your personal display name',
            style: TextStyle(fontSize: 13, color: AppColors.secondColor),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: controller,
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              labelText: 'Full Name',
              filled: true,
              fillColor: AppColors.scaffoldBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.primaryAccent,
                  width: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ButtonWidget(
            content: 'SAVE NAME',
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              await context.read<LoginProvider>().updateName(name);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name updated successfully! ✨')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
