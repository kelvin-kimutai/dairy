import 'package:dairyadmin/views/screens/paymentsScreen.dart';
import 'package:dairyadmin/views/screens/reportScreen.dart';
import 'package:dairyadmin/views/screens/settingsScreen.dart';
import 'package:flutter/material.dart';

import '../views/screens/farmersScreen.dart';
import '../views/screens/homeScreen.dart';
import '../views/screens/loginScreen.dart';

class Routes {
  static final mainRoute = <String, WidgetBuilder>{
    '/': (context) => LoginScreen(),
    '/home': (context) => HomeScreen(),
    '/farmers': (context) => FarmersScreen(),
    '/settings': (context) => SettingsScreen(),
    '/report': (context) => ReportScreen(),
    '/payments': (context) => PaymentsScreen(),
  };
}
