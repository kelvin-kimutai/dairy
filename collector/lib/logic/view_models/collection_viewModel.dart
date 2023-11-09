import 'package:Collector/constants/helper_methods.dart';
import 'package:Collector/constants/theme_colors.dart';
import 'package:Collector/constants/web_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class CollectionViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('collections');
  final CollectionReference usersReference =
      FirebaseFirestore.instance.collection('users');
  CollectionReference settingsReference =
      FirebaseFirestore.instance.collection('settings');
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
    notifyListeners();
  }

  Future<void> getAllFarmers() async {
    farmerIds.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'farmer')
        .where('id', isNotEqualTo: 0)
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

  Future<void> requestCollectionEdit(
      String collectionId, String comment, context) async {
    HelperMethods.showLoadingDialog('Requesting edit...', context);
    await collectionReference.doc(collectionId).update({'comment': comment});
    await sendNotification(comment);
    Navigator.pop(context);
    Navigator.pop(context);
    HelperMethods.showSnackBar(
        'Request submitted.', scaffoldKey, ThemeColors.colorAccent);
  }

  Future<void> sendNotification(String comment) async {
    Map notification = {
      'title': 'Collection Edit Request',
      'body': comment,
      "default_sound": true,
    };
    Map data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ref': 'editRequest',
    };
    QuerySnapshot snapshot =
        await usersReference.where('role', isEqualTo: 'admin').get();
    var user = snapshot.docs[0];
    await WebRepo.sendNotification(user['token'], notification, data);
  }
}
