import 'package:get_it/get_it.dart';

import '../logic/view_models/home_viewModel.dart';
import '../logic/view_models/register_viewModel.dart';
import '../logic/view_models/user_viewModel.dart';
import 'authService.dart';
import 'storage_repo.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  serviceLocator
      .registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  serviceLocator.registerLazySingleton<StorageRepo>(() => StorageRepo());
  serviceLocator.registerLazySingleton<UserViewModel>(() => UserViewModel());
  serviceLocator.registerFactory<HomeViewModel>(() => HomeViewModel());
  serviceLocator.registerFactory<RegisterViewModel>(() => RegisterViewModel());
}
