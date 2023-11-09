import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/helper_methods.dart';
import '../../services/authService.dart';
import '../../services/sevice_locator.dart';
import '../../services/storage_repo.dart';
import '../../views/widgets/codeDialog.dart';
import '../models/user.dart';

class UserViewModel extends ChangeNotifier {
  FirebaseAuthService authService = serviceLocator<FirebaseAuthService>();
  StorageRepo storageRepo = serviceLocator<StorageRepo>();
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  GlobalKey<ScaffoldState> scaffoldKey;
  AppUser appUser = AppUser(id: 0);
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
            var document = await userReference.doc(user.uid).get();
            if (document.exists) {
              await getUserData();
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              Navigator.pushReplacementNamed(context, '/register');
            }
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

  Future<void> getUserData() async {
    await userReference
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((DocumentSnapshot snapshot) async {
      appUser.firstName = snapshot['firstName'];
      appUser.lastName = snapshot['lastName'];
      appUser.avatarUrl = snapshot['avatarUrl'];
      appUser.uid = FirebaseAuth.instance.currentUser.uid;
      appUser.id = await getFarmerId();
    });
  }

  Future<void> updateProfilePicture(File image) async {
    appUser.avatarUrl = await storageRepo.uploadFile(image);
    FirebaseAuth.instance.currentUser
        .updateProfile(photoURL: appUser.avatarUrl);
  }

  Future<void> updateUserData(String firstName, String lastName) async {
    final userDataMap = {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'avatarUrl': appUser.avatarUrl,
      'id': 0,
      'role': 'farmer',
    };
    await userReference
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(userDataMap);
  }

  Future<int> getFarmerId() async {
    int farmerId = 0;
    final document =
        await userReference.doc(FirebaseAuth.instance.currentUser.uid).get();
    farmerId = document['id'];
    return farmerId;
  }
}
