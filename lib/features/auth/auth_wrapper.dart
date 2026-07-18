import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_flow/features/auth/login_screen.dart';
import 'package:task_flow/features/home/home_screen.dart';
import 'package:task_flow/features/home/main_screen.dart'; // تأكد من المسار الصحيح لديك
 
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // الاستماع لحالة تسجيل الدخول المحفوظة تلقائياً في فايربيز
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // أثناء جلب البيانات من فايربيز نعرض مؤشر تحميل
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        // التحقق من وجود مستخدم مسبقاً وأن بريده مفعّل
        if (user != null && user.emailVerified) {
          return const MainScreen(); // يذهب للشاشة الرئيسية مباشرة
        }

        // إذا لم يكن مسجلاً أو لم يفعل حسابه، يذهب لشاشة الدخول
        return const LoginScreen();
      },
    );
  }
}
