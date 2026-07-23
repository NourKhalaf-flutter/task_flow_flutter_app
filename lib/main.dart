 
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/di/injection_container.dart';
import 'package:task_flow/core/routes/app_router.dart';
import 'package:task_flow/core/routes/route_names.dart';
 
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
     initialRoute: RouteNames.authWrapper,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
 