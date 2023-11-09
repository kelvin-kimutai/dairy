import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/helper_methods.dart';
import '../../services/sevice_locator.dart';
import 'user_viewModel.dart';

class RegisterViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  File image;

  void pickImageFromDevice(ImageSource imageSource, context) async {
    image = await HelperMethods.circleCroppedImageFromDevice(
        imageSource: imageSource, imageQuality: 50, context: context);
    notifyListeners();
  }

  Future<void> registerUser({
    String firstName,
    String lastName,
    context,
  }) async {
    bool isConnected = await HelperMethods.checkConnectivity(scaffoldKey);
    if (!isConnected) {
      return;
    }
    if (image == null) {
      HelperMethods.showSnackBar(
          'Please pick a profile picture.', scaffoldKey, Colors.red);
      return;
    }
    if (firstName.length < 3 || lastName.length < 3) {
      HelperMethods.showSnackBar(
          'Please provide a valid name.', scaffoldKey, Colors.red);
      return;
    }
    HelperMethods.showLoadingDialog('Creating your account...', context);
    await serviceLocator<UserViewModel>().updateProfilePicture(image);
    await serviceLocator<UserViewModel>()
        .updateUserData(firstName.trim(), lastName.trim());
    await serviceLocator<UserViewModel>().getUserData();
    Navigator.pushReplacementNamed(context, '/home');
  }
}
