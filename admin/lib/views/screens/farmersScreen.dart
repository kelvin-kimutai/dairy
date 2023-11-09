import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/sevice_locator.dart';
import '../../constants/theme_colors.dart';
import '../../logic/view_models/farmers_viewModel.dart';
import '../widgets/farmer_card.dart';
import '../widgets/nav_drawer.dart';

class FarmersScreen extends StatefulWidget {
  FarmersScreen({Key key}) : super(key: key);

  @override
  _FarmersScreenState createState() => _FarmersScreenState();
}

class _FarmersScreenState extends State<FarmersScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  FarmersViewModel model = serviceLocator<FarmersViewModel>();

  @override
  void initState() {
    model.scaffoldKey = scaffoldKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Farmers'),
      ),
      drawer: CustomDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'farmer')
            .orderBy('id', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var farmer = snapshot.data.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FarmerCard(
                      farmer: farmer,
                      editId: editFarmerDetails,
                      viewReport: viewFarmerReport),
                );
              },
            );
          }
        },
      ),
    );
  }

  void viewFarmerReport(int id, String name) {
    Navigator.pushNamed(context, '/report',
        arguments: {'id': id, 'name': name});
  }

  void editFarmerDetails(String farmerUid) {
    TextEditingController idController = TextEditingController();
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Edit farmer details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.phone,
              controller: idController,
              decoration: InputDecoration(hintText: 'Farmer ID'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: () {
                    model.updateFarmerId(
                        farmerUid, int.parse(idController.text));
                    Navigator.pop(context);
                  },
                  color: ThemeColors.colorAccent,
                  minWidth: 50,
                  textColor: Colors.white,
                  child: Text(
                    'Update',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
