import 'package:dairyadmin/constants/theme_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'constants/routes.dart';
import 'constants/sevice_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServiceLocator();
  runApp(
    MaterialApp(
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
  );
}
