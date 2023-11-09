import 'package:Collector/views/screens/homeScreen.dart';
import 'package:Collector/views/screens/loginScreen.dart';
import 'package:flutter/material.dart';

class Routes {
  static final mainRoute = <String, WidgetBuilder>{
    '/': (context) => LoginScreen(),
    '/home': (context) => HomeScreen(),
  };
}
