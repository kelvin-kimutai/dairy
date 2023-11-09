import 'package:farmer/constants/theme_colors.dart';
import 'package:farmer/logic/view_models/home_viewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/routes.dart';
import 'services/sevice_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();
  runApp(ChangeNotifierProvider(
    create: (context) => serviceLocator<HomeViewModel>(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primaryColor: ThemeColors.colorPrimary,
        accentColor: ThemeColors.colorAccent,
        colorScheme: ColorScheme.light(primary: ThemeColors.colorPrimary),
      ),
      routes: Routes.mainRoute,
      initialRoute: FirebaseAuth.instance.currentUser != null ? '/home' : '/',
    ),
  ));
}
