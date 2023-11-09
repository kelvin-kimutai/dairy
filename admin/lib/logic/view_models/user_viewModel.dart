import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyadmin/constants/sevice_locator.dart';
import 'package:dairyadmin/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/helper_methods.dart';
import '../../views/widgets/codeDialog.dart';
import '../models/user.dart';

class UserViewModel extends ChangeNotifier {
  FirebaseAuthService authService = serviceLocator<FirebaseAuthService>();
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  GlobalKey<ScaffoldState> scaffoldKey;
  AppUser appUser = AppUser();
  String phoneNumber;
  User user;

  void loginUser(String phone, BuildContext context) async {
    bool isConnected = await HelperMethods.checkConnectivity(scaffoldKey);
    if (!isConnected) {
      return;
    }
    phoneNumber = phone.trim();
    if (phoneNumber.length != 10 || phoneNumber.substring(0, 2) != '07') {
      HelperMethods.showSnackBar(
          'Please use the 07-xx-xxx-xxx format.', scaffoldKey, Colors.red);
      return;
    }
    phoneNumber = '+254' + phoneNumber.substring(1);
    HelperMethods.showLoadingDialog('Loading...', context);
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          UserCredential result = await _auth.signInWithCredential(credential);
          user = result.user;
          if (user != null) {
            await updateUserData();
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            HelperMethods.showSnackBar('Error.', scaffoldKey, Colors.red);
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          Navigator.pop(context);
          if (exception.code == 'invalid-phone-number') {
            HelperMethods.showSnackBar(phoneNumber, scaffoldKey, Colors.red);
          } else {
            HelperMethods.showSnackBar(exception.code, scaffoldKey, Colors.red);
          }
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          Navigator.pop(context);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => CodeDialog(
              verificationId: verificationId,
              scaffoldKey: scaffoldKey,
            ),
          );
        },
        codeAutoRetrievalTimeout: (_) {});
  }

  Future<void> updateUserData() async {
    final userDataMap = {
      'role': 'admin',
    };
    await userReference
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(userDataMap);
  }
}
