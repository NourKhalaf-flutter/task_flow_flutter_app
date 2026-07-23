import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_images.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:task_flow/core/routes/route_names.dart';
import 'package:task_flow/core/utils/validators.dart';
import 'package:task_flow/core/widgets/button_widget.dart';
import 'package:task_flow/core/widgets/text_form_field.dart';
import 'package:task_flow/features/auth/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isHide = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 87, 20, 20),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Welcome Back!',
                    style: AppTextStyles.font32MainInter700,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'sign in to continue',
                    style: AppTextStyles.font16SecondSans,
                  ),
                  const SizedBox(height: 30),
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
                    obscureText: isHide,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isHide = !isHide;
                          });
                        },
                        icon: Icon(
                          isHide
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.forgotPasswordScreen,
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: AppTextStyles.font16MainSans,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Consumer<LoginProvider>(
                    builder:
                        (BuildContext context, authProvider, Widget? child) {
                          return authProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ButtonWidget(
                                  content: 'SIGN IN',
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    final email = _emailController.text.trim();
                                    final password = _passwordController.text;

                                    await authProvider.login(email, password);

                                    if (authProvider.isLoggedIn) {
                                      // NotificationService().showNotification(
                                      //   title: 'Success Login',
                                      //   body: 'Welcome, start shopping now!',
                                      // );

                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        RouteNames.mainScreen,

                                        (route) => false,
                                      );
                                    } else if (authProvider.errorMessage !=
                                        null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            authProvider.errorMessage!,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                        },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: AppTextStyles.font16SecondSans,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.signupScreen);
                        },
                        child: Text(
                          'Sign up.',
                          style: AppTextStyles.font16MainSans,
                        ),
                      ),
                    ],
                  ),
                  // Spacer(),
                  const SizedBox(height: 30),
                  Consumer<LoginProvider>(
                    builder:
                        (BuildContext context, authProvider, Widget? child) {
                          return authProvider.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Container(
                                  width: .infinity,
                                  decoration: BoxDecoration(
                                    border: .all(color: AppColors.borderColor),
                                    borderRadius: .circular(5),
                                  ),
                                  height: 50,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      authProvider.signInWithGoogle();
                                    },
                                    icon: SvgPicture.asset(AppSvgs.google),
                                    label: Text(
                                      'SIGN IN With GOOGLE',
                                      style: GoogleFonts.dmSans(
                                        color: AppColors.secondColor,
                                        fontWeight: .bold,
                                      ),
                                    ),
                                  ),
                                );
                        },
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
