import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/sevice_locator.dart';
import 'user_viewModel.dart';

class HomeViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  UserViewModel userViewModel = serviceLocator<UserViewModel>();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('collections');
  CollectionReference receiptsReference =
      FirebaseFirestore.instance.collection('receipts');
  double amountDue = 0;
  int pending = 0;

  Future<void> signOut() async {
    // await userViewModel.signOut();
  }

  Future<void> getAmountDue() async {
    amountDue = 0;
    QuerySnapshot snapshot = await collectionReference
        .where('id', isEqualTo: userViewModel.appUser.id)
        .where('status', isEqualTo: 'Pending')
        .get();
    var collections = snapshot.docs;
    for (var collection in collections) {
      amountDue += collection['kgs'] * collection['price'];
    }
    notifyListeners();
  }

  Future<void> getPayments() async {
    QuerySnapshot snapshot = await receiptsReference
        .where('id', isEqualTo: userViewModel.appUser.id)
        .where('viewed', isEqualTo: false)
        .get();
    var payments = snapshot.docs;
    pending = payments.length;
    notifyListeners();
  }

  Future<void> viewPayments() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    await receiptsReference
        .where('id', isEqualTo: userViewModel.appUser.id)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.update(document.reference, {'viewed': true});
      });
      return batch.commit();
    });
    pending = 0;
    notifyListeners();
  }
}
