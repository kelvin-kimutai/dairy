import 'package:Collector/views/widgets/loading_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class HelperMethods {
  static showSnackBar(
      String label, GlobalKey<ScaffoldState> scaffoldKey, Color color) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(
        label,
        textAlign: TextAlign.center,
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  static showLoadingDialog(String text, context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(status: text));
  }

  static Future<bool> checkConnectivity(
      GlobalKey<ScaffoldState> scaffoldKey) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showSnackBar(
          'Check your internet connectivity.', scaffoldKey, Colors.red);
      return false;
    } else {
      return true;
    }
  }
}
