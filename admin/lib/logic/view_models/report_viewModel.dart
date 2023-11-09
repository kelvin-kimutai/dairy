import 'package:dairyadmin/services/web_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('collections');
  CollectionReference usersReference =
      FirebaseFirestore.instance.collection('users');
  CollectionReference receiptsReference =
      FirebaseFirestore.instance.collection('receipts');
  double amountDue = 0;
  int farmerId = 0;

  Future<void> getAmountDue() async {
    amountDue = 0;
    QuerySnapshot snapshot = await collectionReference
        .where('id', isEqualTo: farmerId)
        .where('status', isEqualTo: 'Pending')
        .get();
    var collections = snapshot.docs;
    for (var collection in collections) {
      amountDue += (collection['kgs'] * collection['price']);
    }
    notifyListeners();
  }

  Future<void> payFarmer() async {
    await receiptsReference
        .add({'id': farmerId, 'amount': amountDue, 'dateTime': DateTime.now()});

    WriteBatch batch = FirebaseFirestore.instance.batch();
    await collectionReference
        .where('id', isEqualTo: farmerId)
        .where('status', isEqualTo: 'Pending')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.update(document.reference, {'status': 'Cleared'});
      });
      return batch.commit();
    });
    sendNotification();
  }

  Future<void> sendNotification() async {
    Map notification = {
      'title': 'Milk payment',
      'body': 'Your payment of ksh $amountDue has been processed.',
      "default_sound": true,
    };

    Map data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ref': 'payment',
    };

    QuerySnapshot snapshot =
        await usersReference.where('id', isEqualTo: farmerId).get();
    var farmer = snapshot.docs[0];

    WebRepo.sendNotification(farmer['token'], notification, data);

    amountDue = 0;
    notifyListeners();
  }
}
