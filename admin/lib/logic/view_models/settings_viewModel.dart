import 'package:dairyadmin/constants/helper_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  CollectionReference settingsReference =
      FirebaseFirestore.instance.collection('settings');
  int currentPrice = 0;

  Future<void> getCurrentPrice() async {
    await settingsReference
        .doc('settings')
        .get()
        .then((DocumentSnapshot document) {
      if (document == null || !document.exists) {
        settingsReference.doc('settings').set({'currentPrice': 0.00});
      } else {
        currentPrice = document['currentPrice'];
      }
    });
    notifyListeners();
  }

  Future<void> updateCurrentPrice(int price, context) async {
    settingsReference.doc('settings').update({'currentPrice': price});
    Navigator.pop(context);
    currentPrice = price;
    notifyListeners();
    HelperMethods.showSnackBar(
        'Price updated successfuly', scaffoldKey, Colors.green);
  }
}
