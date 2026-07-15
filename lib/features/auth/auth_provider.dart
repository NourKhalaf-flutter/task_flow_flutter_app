import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool isLoggedIn = false;
  bool isOnBoradingComplete = false;

  String? name;
  String? email;

  // Future<void> loadUserData() async {
  //   name = appPreferences.getUserName();
  //   email = appPreferences.getUserEmail();
  //   notifyListeners();
  // }

 

  Future<void> register(String emailAddress, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      // 1. إنشاء حساب مستخدم جديد في فايربيز
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailAddress,
            password: password,
          );

      final user = credential.user;
      if (user != null) {
        // 2. إرسال رابط التحقق إلى البريد الإلكتروني للمستخدم
        await user.sendEmailVerification();

        // 3. تسجيل الخروج فوراً لأن الحساب لم يتم تفعيله بعد
        await FirebaseAuth.instance.signOut();

        isLoggedIn = false;
        // نضع رسالة نجاح في errorMessage ليتم عرضها للمستخدم في الواجهة
        errorMessage =
            'تم إنشاء الحساب بنجاح! يرجى تفعيل حسابك من خلال الرابط المرسل إلى بريدك الإلكتروني قبل تسجيل الدخول.';
      }
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String emailAddress, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      // 1. تسجيل الدخول بالبريد وكلمة المرور
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // 2. تحديث بيانات المستخدم فوراً لجلب حالة التفعيل الجديدة
        await user.reload();

        // 3. الحصول على كائن المستخدم بنسخته المحدثة
        final updatedUser = FirebaseAuth.instance.currentUser;

        // 4. التحقق من حالة التفعيل
        if (updatedUser != null && updatedUser.emailVerified) {
          isLoggedIn = true; // مسموح له بالدخول
          errorMessage = null;
        } else {
          isLoggedIn = false; // غير مسموح له بالدخول
          await FirebaseAuth.instance.signOut(); // تسجيل خروجه لحين التفعيل
          errorMessage =
              'الحساب غير مفعّل. يرجى التحقق من بريدك الإلكتروني والنقر على رابط التفعيل أولاً.';
        }
      }
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

    Future<void> logout() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try { 
      await FirebaseAuth.instance.signOut();
      isLoggedIn = false;
      name = null;
      email = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
