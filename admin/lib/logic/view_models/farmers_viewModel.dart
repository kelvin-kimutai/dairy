import 'package:dairyadmin/constants/helper_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FarmersViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  CollectionReference farmerCollectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateFarmerId(String farmerUid, int id) async {
    List<int> farmerIds = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'farmer')
        .get();
    List<QueryDocumentSnapshot> farmers = snapshot.docs;
    for (var farmer in farmers) {
      farmerIds.add(farmer['id']);
    }

    if (farmerIds.contains(id)) {
      HelperMethods.showSnackBar(
          'ID is already taken', scaffoldKey, Colors.red);
      return;
    }

    DocumentReference farmer = farmerCollectionReference.doc(farmerUid);
    farmer.update({'id': id});
    HelperMethods.showSnackBar(
        'Details updated successfuly', scaffoldKey, Colors.green);
  }
}
