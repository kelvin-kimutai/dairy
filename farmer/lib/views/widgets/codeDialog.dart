import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/logic/view_models/user_viewModel.dart';
import 'package:farmer/services/sevice_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/helper_methods.dart';

class CodeDialog extends StatefulWidget {
  final String verificationId;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CodeDialog({Key key, this.verificationId, this.scaffoldKey})
      : super(key: key);

  @override
  _CodeDialogState createState() => _CodeDialogState();
}

class _CodeDialogState extends State<CodeDialog> {
  final _codeController = TextEditingController();
  UserViewModel model = serviceLocator<UserViewModel>();

  void verifyCode() async {
    bool isConnected =
        await HelperMethods.checkConnectivity(widget.scaffoldKey);
    if (!isConnected) {
      return;
    }

    final code = _codeController.text.trim();
    FirebaseAuth _auth = FirebaseAuth.instance;
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: code);
    HelperMethods.showLoadingDialog('Please wait...', context);

    try {
      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user;
      if (user != null) {
        var document = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (document.exists) {
          await model.getUserData();
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/register');
        }
      } else {
        HelperMethods.showSnackBar('Error', widget.scaffoldKey, Colors.red);
      }
    } on Exception {
      Navigator.pop(context);
      HelperMethods.showSnackBar(
          'Invalid code', widget.scaffoldKey, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Give the code?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Confirm"),
          textColor: Colors.white,
          color: Colors.blue,
          onPressed: verifyCode,
        )
      ],
    );
  }
}
