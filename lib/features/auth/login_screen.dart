import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/routes/route_names.dart';
import 'package:task_flow/core/utils/validators.dart';
import 'package:task_flow/core/widgets/ambient_glow_background.dart';
import 'package:task_flow/core/widgets/button_widget.dart';
import 'package:task_flow/core/widgets/google_auth_button.dart';
import 'package:task_flow/core/widgets/text_form_field.dart';
import 'package:task_flow/features/auth/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showFeedbackSnackBar(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: isError ? AppColors.mainColor : AppColors.mintAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderColor),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: AppColors.mainColor,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: AmbientGlowBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand Emblem
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryAccent, Color(0xFF4F46E5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryAccent.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.task_alt_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Header Typography
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainColor,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to access your workspace and tasks',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          color: AppColors.secondColor,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email Field
                      TextFormFieldWidget(
                        controller: _emailController,
                        label: 'Email Address',
                        hintText: 'name@example.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(
                          Icons.mail_outline_rounded,
                          size: 20,
                        ),
                        validator: (value) => Validators.validateEmail(
                          value,
                          'Please enter your email',
                          'Please enter a valid email address.',
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Password Field
                      TextFormFieldWidget(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: '••••••••',
                        obscureText: _isPasswordHidden,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                          icon: Icon(
                            _isPasswordHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: AppColors.secondColor,
                          ),
                        ),
                        validator: (value) => Validators.validatePassword(
                          value,
                          'Please enter your password',
                          'Password must be at least 8 characters',
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.forgotPasswordScreen,
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Sign In Button
                      Consumer<LoginProvider>(
                        builder: (context, authProvider, child) {
                          return authProvider.isLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : ButtonWidget(
                                  content: 'Sign In',
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    final email = _emailController.text.trim();
                                    final password = _passwordController.text;

                                    await authProvider.login(email, password);

                                    if (!context.mounted) return;

                                    if (authProvider.isLoggedIn) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        RouteNames.mainScreen,
                                        (route) => false,
                                      );
                                    } else if (authProvider.errorMessage != null) {
                                      _showFeedbackSnackBar(
                                        authProvider.errorMessage!,
                                        isError: true,
                                      );
                                    }
                                  },
                                );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Or Continue With Divider
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: AppColors.borderColor,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Or continue with',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondColor,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: AppColors.borderColor,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Google Sign In Button
                      Consumer<LoginProvider>(
                        builder: (context, authProvider, child) {
                          return GoogleAuthButton(
                            label: 'Continue with Google',
                            onPressed: () async {
                              await authProvider.signInWithGoogle();
                              if (!context.mounted) return;

                              if (authProvider.isLoggedIn) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteNames.mainScreen,
                                  (route) => false,
                                );
                              } else if (authProvider.errorMessage != null) {
                                _showFeedbackSnackBar(
                                  authProvider.errorMessage!,
                                  isError: true,
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Toggle to Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: AppColors.secondColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.signupScreen,
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
