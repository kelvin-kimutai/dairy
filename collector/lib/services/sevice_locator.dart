import 'package:Collector/logic/view_models/user_viewModel.dart';
import 'package:Collector/services/authService.dart';
import 'package:get_it/get_it.dart';

import '../logic/view_models/collection_viewModel.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  //Factory
  serviceLocator
      .registerFactory<FirebaseAuthService>(() => FirebaseAuthService());
  //Singleton
  serviceLocator
      .registerLazySingleton<CollectionViewModel>(() => CollectionViewModel());
  serviceLocator.registerLazySingleton<UserViewModel>(() => UserViewModel());
}
