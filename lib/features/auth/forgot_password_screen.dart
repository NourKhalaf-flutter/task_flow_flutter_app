import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';
import 'package:task_flow/core/routes/route_names.dart';
import 'package:task_flow/core/utils/validators.dart';
import 'package:task_flow/core/widgets/button_widget.dart';
import 'package:task_flow/core/widgets/text_form_field.dart';
import 'package:task_flow/features/auth/auth_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
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
                    'Please enter your email address. You will receive a link to create a new password via email.',
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

                  const SizedBox(height: 30),
                  Consumer<AuthProvider>(
                    builder: (BuildContext context, authProvider, Widget? child) {
                      return authProvider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ButtonWidget(
                              content: 'SEND',
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                final email = _emailController.text.trim();

                                await authProvider.resetPassword(email);

                                if (authProvider.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(authProvider.errorMessage!),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'تم إرسال رابط إعادة تعيين كلمة المرور بنجاح!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                 
                                  await Future.delayed(
                                    const Duration(seconds: 2),
                                  );

                                   // use "mounted" to check if the widget is still in the tree,
                                   // if the user close the widget before the delay time it will throw exception                                                             
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                } 
                              },
                            );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
