import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/login_provider.dart';
import '../../features/category/data/datasources/categories_remote_data_source.dart';
import '../../features/category/data/ropositories/categories_repositories_impl.dart';
import '../../features/category/domain/repositories/categories_repository.dart';
import '../../features/category/domain/usecases/add_category.dart';
import '../../features/category/domain/usecases/get_categories.dart';
import '../../features/category/presentation/provider/categories_provider.dart';
import '../../features/tasks/data/datasources/tasks_remote_data_source.dart';
import '../../features/tasks/data/repositories/tasks_repository_impl.dart';
import '../../features/tasks/domain/repositories/tasks_repository.dart';
import '../../features/tasks/domain/usecases/add_task.dart';
import '../../features/tasks/domain/usecases/get_tasks.dart';
import '../../features/tasks/presentation/provider/tasks_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core
  //! External
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => Dio());

  // Helpers
  // Services
  //sl.registerLazySingleton<AppPreferences>(() => AppPreferences(sl()));

  // =========================
  // Firebase
  // =========================

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //! Features

  // Login Provider

  sl.registerFactory(() => LoginProvider());
  
  // Category Data Source

  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );

  // Category Repository

  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(sl()),
  );

  // Category Use Cases

  sl.registerLazySingleton(() => AddCategoryUseCase(sl()));

  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  // Category Provider

  sl.registerFactory(
    () => CategoriesProvider(
      addCategoryUseCase: sl(),
      getCategoriesUseCase: sl(),
    ),
  );

  // Tasks Data Source

  sl.registerLazySingleton<TasksRemoteDataSource>(
    () => TasksRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );

  // Tasks Repository

  sl.registerLazySingleton<TasksRepository>(() => TasksRepositoryImpl(sl()));

  // Tasks Use Cases

  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));

  // sl.registerLazySingleton(
  //   () => GetTasksUseCase(
  //     sl(),
  //   ),
  // );

  // Tasks Provider

  sl.registerFactory(
    () => TasksProvider(
      addTaskUseCase: sl(),
      getTasksUseCase: sl(),
      // getTasksUseCase: sl(),
    ),
  );

  // sl.registerLazySingleton(() => AppDbHelper());
}
