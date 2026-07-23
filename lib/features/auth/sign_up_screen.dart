import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_images.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:task_flow/core/utils/validators.dart';
import 'package:task_flow/core/widgets/button_widget.dart';
import 'package:task_flow/core/widgets/text_form_field.dart';
import 'package:task_flow/features/auth/login_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isHidePassword = true;
  bool isHideConfirmPassword = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context); // العودة للخلف (شاشة تسجيل الدخول)
          },
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 40, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: AppTextStyles.font32MainInter700,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'sign up to get started',
                    style: AppTextStyles.font16SecondSans,
                  ),
                  const SizedBox(height: 30),

                  TextFormFieldWidget(
                    controller: _nameController,
                    label: 'FULL NAME',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormFieldWidget(
                    controller: _emailController,
                    label: 'EMAIL',
                    validator: (value) => Validators.validateEmail(
                      value,
                      'Please enter your email',
                      'Please enter a valid email address.',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldWidget(
                    label: 'PASSWORD',
                    controller: _passwordController,
                    validator: (value) => Validators.validatePassword(
                      value,
                      'Please enter your password',
                      'The password should be at least 8 characters',
                    ),
                    obscureText: isHidePassword,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isHidePassword = !isHidePassword;
                          });
                        },
                        icon: Icon(
                          isHidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  TextFormFieldWidget(
                    label: 'CONFIRM PASSWORD',
                    controller: _confirmPasswordController,
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    obscureText: isHideConfirmPassword,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isHideConfirmPassword = !isHideConfirmPassword;
                          });
                        },
                        icon: Icon(
                          isHideConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Consumer<LoginProvider>(
                    builder: (BuildContext context, authProvider, Widget? child) {
                      return authProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ButtonWidget(
                              content: 'SIGN UP',
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                final email = _emailController.text.trim();
                                final password = _passwordController.text;
                                final name = _nameController.text;

                                await authProvider.register(email, password,name);

                                if (authProvider.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(authProvider.errorMessage!),
                                      duration: const Duration(seconds: 6),
                                    ),
                                  );

                                  // إذا نجحت العملية (حيث نص رسالة النجاح يحتوي على "تم إنشاء الحساب")
                                  // نقوم بإعادة المستخدم تلقائياً لشاشة تسجيل الدخول
                                  if (authProvider.errorMessage!.contains(
                                    'بنجاح',
                                  )) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                            );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.font16SecondSans,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // العودة لشاشة تسجيل الدخول
                        },
                        child: Text(
                          'Sign in.',
                          style: AppTextStyles.font16MainSans,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // زر التسجيل عبر جوجل بنفس تصميم زر تسجيل الدخول
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 50,
                    child: TextButton.icon(
                      onPressed: () {
                        // كود التسجيل باستخدام جوجل مستقبلاً
                      },
                      icon: SvgPicture.asset(AppSvgs.google),
                      label: Text(
                        'SIGN UP With GOOGLE',
                        style: GoogleFonts.dmSans(
                          color: AppColors.secondColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
