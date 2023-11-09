import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:farmer/views/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  static Future<File> circleCroppedImageFromDevice(
      {ImageSource imageSource, int imageQuality, context}) async {
    File image =
        // ignore: deprecated_member_use
        await ImagePicker.pickImage(source: imageSource, imageQuality: 50);
    var res;
    if (image != null) {
      res = await Navigator.pushNamed(context, '/crop',
          arguments: {'image': image});
      image = res;
    }
    return image;
  }
}
