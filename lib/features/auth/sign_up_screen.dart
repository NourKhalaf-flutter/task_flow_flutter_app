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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showFeedbackSnackBar(String message, {bool isSuccess = false}) {
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
        backgroundColor: isSuccess ? AppColors.mintAccent : AppColors.mainColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: isSuccess ? 6 : 4),
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
        leading: IconButton(
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
        ),
      ),
      body: AmbientGlowBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
                        'Create Account',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainColor,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign up to streamline your workflow and daily goals',
                        style: GoogleFonts.dmSans(
                          fontSize: 15,
                          color: AppColors.secondColor,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Full Name Field
                      TextFormFieldWidget(
                        controller: _nameController,
                        label: 'Full Name',
                        hintText: 'John Doe',
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          size: 20,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

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
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormFieldWidget(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: '••••••••',
                        obscureText: _isPasswordHidden,
                        textInputAction: TextInputAction.next,
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
                      const SizedBox(height: 16),

                      // Confirm Password Field
                      TextFormFieldWidget(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hintText: '••••••••',
                        obscureText: _isConfirmPasswordHidden,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(
                          Icons.shield_outlined,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                            });
                          },
                          icon: Icon(
                            _isConfirmPasswordHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: AppColors.secondColor,
                          ),
                        ),
                        validator: (value) => Validators.validateConfirmPassword(
                          value,
                          _passwordController.text,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Sign Up Button
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
                                  content: 'Create Account',
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }

                                    final email = _emailController.text.trim();
                                    final password = _passwordController.text;
                                    final name = _nameController.text.trim();

                                    await authProvider.register(
                                      email,
                                      password,
                                      name,
                                    );

                                    if (!context.mounted) return;

                                    if (authProvider.errorMessage != null) {
                                      final isSuccess = authProvider.errorMessage!
                                          .contains('بنجاح');
                                      _showFeedbackSnackBar(
                                        authProvider.errorMessage!,
                                        isSuccess: isSuccess,
                                      );

                                      if (isSuccess) {
                                        Navigator.pop(context);
                                      }
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

                      // Google Sign Up Button
                      Consumer<LoginProvider>(
                        builder: (context, authProvider, child) {
                          return GoogleAuthButton(
                            label: 'Sign up with Google',
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
                                  isSuccess: false,
                                );
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Toggle to Sign In
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: AppColors.secondColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Sign in',
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
