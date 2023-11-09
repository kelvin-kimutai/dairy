import 'package:dairyadmin/constants/sevice_locator.dart';
import 'package:dairyadmin/logic/view_models/payments_viewModel.dart';
import 'package:dairyadmin/views/widgets/nav_drawer.dart';
import 'package:dairyadmin/views/widgets/receipt_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentsScreen extends StatefulWidget {
  PaymentsScreen({Key key}) : super(key: key);

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  PaymentsViewModel model = serviceLocator<PaymentsViewModel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Payments'),
      ),
      drawer: CustomDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('receipts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var receipt = snapshot.data.docs[index];
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ReceiptCard(
                      receipt: receipt,
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
