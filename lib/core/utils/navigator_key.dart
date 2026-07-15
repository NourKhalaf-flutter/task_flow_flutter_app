import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


// ينشئ مفتاح جديد يمكنك استخدامه 
// Navigator للوصول مباشرةً إلى 
// من أي مكان في التطبيق، حتى من خارج
// BuildContext الـ
// الخاص بالشاشة الحالية