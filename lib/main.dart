 
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/di/injection_container.dart';
import 'package:task_flow/core/routes/app_router.dart';
 
import 'package:task_flow/features/splash/splash_screen.dart';
import 'package:task_flow/features/tasks/presentation/provider/tasks_provider.dart';
import 'package:task_flow/firebase_options.dart';
import 'features/auth/login_provider.dart';
 
import 'features/category/presentation/provider/categories_provider.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); // GetIt initialization
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 


  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<LoginProvider>()),
    
    ChangeNotifierProvider(
      create: (_) => sl<CategoriesProvider>(),
    ),


    ChangeNotifierProvider(
      create: (_) => sl<TasksProvider>(),
    ),
 
          ],          
      child:
      MyApp(appRouter: AppRouter())));
}

class MyApp extends StatelessWidget {
 final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryAccent,
          primary: AppColors.primaryAccent,
          surface: AppColors.scaffoldBackground,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      home: const SplashScreen(),
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
 