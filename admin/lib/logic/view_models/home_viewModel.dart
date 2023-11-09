import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyadmin/constants/helper_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('collections');
  CollectionReference settingsReference =
      FirebaseFirestore.instance.collection('settings');
  final CollectionReference usersReference =
      FirebaseFirestore.instance.collection('users');
  int currentPrice;
  List<QueryDocumentSnapshot> farmers = [];
  List<String> farmerIds = [];

  Future<void> getCurrentPrice() async {
    await settingsReference
        .doc('settings')
        .get()
        .then((DocumentSnapshot document) {
      currentPrice = document['currentPrice'];
    });
  }

  Future<void> getAllFarmers() async {
    farmerIds.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'farmer')
        .get();
    farmers = snapshot.docs;
    for (var farmer in farmers) {
      farmerIds.add(farmer['id'].toString());
    }
    notifyListeners();
  }

  Future<void> addCollection(
      String kgs, String id, String date, context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Navigator.of(context).pop();
      HelperMethods.showSnackBar(
          'Please check your internet connectivity.', scaffoldKey, Colors.red);
      return;
    }
    if (kgs.isEmpty || id.isEmpty) {
      Navigator.of(context).pop();
      HelperMethods.showSnackBar(
          'Please fill in all the fields.', scaffoldKey, Colors.red);
      return;
    }
    if (!farmerIds.contains(id)) {
      Navigator.of(context).pop();
      HelperMethods.showSnackBar(
          'Farmer ID does not exist.', scaffoldKey, Colors.red);
      return;
    }
    HelperMethods.showLoadingDialog('Adding collection...', context);

    await getCurrentPrice();
    await collectionReference.add({
      'price': currentPrice,
      'kgs': double.parse(kgs),
      'date': date,
      'time': DateTime.now(),
      'status': 'Pending',
      'comment': "",
      'id': int.parse(id)
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    HelperMethods.showSnackBar('Collection added.', scaffoldKey, Colors.green);
  }

  Future<void> deleteCollection(String docId) async {
    await collectionReference.doc(docId).delete();
    HelperMethods.showSnackBar(
        'Collection removed.', scaffoldKey, Colors.green);
  }

  Future<void> editCollection(
      String kgs, String farmerId, String collectionId, context) async {
    if (!farmerIds.contains(farmerId)) {
      Navigator.of(context).pop();
      HelperMethods.showSnackBar(
          'Farmer ID does not exist.', scaffoldKey, Colors.red);
      return;
    }
    HelperMethods.showLoadingDialog('Updating collection...', context);
    await collectionReference.doc(collectionId).update({
      'id': int.parse(farmerId),
      'price': currentPrice,
      'kgs': double.parse(kgs),
      'comment': "",
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    HelperMethods.showSnackBar(
        'Collection updated.', scaffoldKey, Colors.green);
  }
}
