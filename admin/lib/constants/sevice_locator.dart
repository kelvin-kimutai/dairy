import 'package:dairyadmin/logic/view_models/payments_viewModel.dart';
import 'package:dairyadmin/logic/view_models/report_viewModel.dart';
import 'package:dairyadmin/logic/view_models/settings_viewModel.dart';
import 'package:dairyadmin/services/authService.dart';
import 'package:get_it/get_it.dart';

import '../logic/view_models/home_viewModel.dart';
import '../logic/view_models/farmers_viewModel.dart';
import '../logic/view_models/user_viewModel.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  //Factory
  serviceLocator
      .registerFactory<FirebaseAuthService>(() => FirebaseAuthService());
  serviceLocator.registerFactory<FarmersViewModel>(() => FarmersViewModel());
  serviceLocator.registerFactory<SettingsViewModel>(() => SettingsViewModel());
  serviceLocator.registerFactory<ReportViewModel>(() => ReportViewModel());
  serviceLocator.registerFactory<PaymentsViewModel>(() => PaymentsViewModel());
  //Singleton
  serviceLocator.registerLazySingleton<HomeViewModel>(() => HomeViewModel());
  serviceLocator.registerLazySingleton<UserViewModel>(() => UserViewModel());
}
