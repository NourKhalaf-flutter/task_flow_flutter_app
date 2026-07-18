import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:task_flow/features/auth/user_model.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  bool isLoggedIn = false;
  bool isOnBoradingComplete = false;

  // String? name;
  // String? email;
  UserModel? currentUser;

  Future<void> loadUserData() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        currentUser = UserModel.fromMap(doc.data()!);
        notifyListeners();
      }
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> register(
    String emailAddress,
    String password,
    String name,
  ) async {
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
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': emailAddress,
          'createdAt':
              FieldValue.serverTimestamp(), // وقت التخزين الفعلي من السيرفر
        });

        // 3. إرسال رابط التحقق إلى البريد الإلكتروني للمستخدم
        await user.sendEmailVerification();

        // 4. تسجيل الخروج فوراً لأن الحساب لم يتم تفعيله بعد
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
                loadUserData();

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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // User cancelled the sign-in
      if (googleUser == null) {
        return null;
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);

        final doc = await userDoc.get();

        if (!doc.exists) {
          await userDoc.set({
            'uid': user.uid,
            'name': user.displayName,
            'email': user.email,

            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        isLoggedIn = true;
              loadUserData();

      }

      return userCredential;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await GoogleSignIn().signOut();

      await FirebaseAuth.instance.signOut();
      isLoggedIn = false;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

Future<void> updateName(String newName) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      'name': newName,
    });

    currentUser = currentUser!.copyWith(
      name: newName,
    );

    notifyListeners();

  } catch (e) {
    errorMessage = e.toString();
    notifyListeners();
  }
}
}
