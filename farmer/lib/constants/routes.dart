import 'package:farmer/views/screens/crop_screen.dart';
import 'package:farmer/views/screens/homeScreen.dart';
import 'package:farmer/views/screens/loginScreen.dart';
import 'package:farmer/views/screens/registerScreen.dart';
import 'package:flutter/material.dart';

class Routes {
  static final mainRoute = <String, WidgetBuilder>{
    '/': (context) => LoginScreen(),
    '/home': (context) => HomeScreen(),
    '/crop': (context) => SimpleCropRoute(),
    '/register': (context) => RegisterScreen(),
  };
}
