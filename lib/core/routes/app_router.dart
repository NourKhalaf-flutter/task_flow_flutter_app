import 'package:task_flow/features/auth/auth_wrapper.dart';
import 'package:task_flow/features/auth/forgot_password_screen.dart';
import 'package:task_flow/features/auth/login_screen.dart';
import 'package:task_flow/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:task_flow/features/auth/sign_up_screen.dart';
import 'package:task_flow/features/home/home_screen.dart';
import 'package:task_flow/features/home/main_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.authWrapper:
        return _buildRoute(const AuthWrapper(), settings);

      //login
      case RouteNames.mainScreen:
        return _buildRoute(const MainScreen(), settings);
      case RouteNames.loginScreen:
        return _buildRoute(const LoginScreen(), settings);
      case RouteNames.signupScreen:
        return _buildRoute(const SignUpScreen(), settings);
      case RouteNames.forgotPasswordScreen:
        return _buildRoute(const ForgotPasswordScreen(), settings);
      case RouteNames.homeScreen:
        return _buildRoute(const HomeScreen(), settings);

      default:
        return _buildRoute(const _UnknownRouteScreen(), settings);
    }
  }

  // Helper method لبناء الـ Route

  static MaterialPageRoute<T> _buildRoute<T>(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<T>(builder: (_) => page, settings: settings);
  }
}

// صفحة للـ routes غير الموجودة
class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خطأ')),
      body: const Center(
        child: Text('الصفحة غير موجودة', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
