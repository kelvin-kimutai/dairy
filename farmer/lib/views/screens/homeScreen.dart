import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer/constants/helper_methods.dart';
import 'package:farmer/constants/theme_colors.dart';
import 'package:farmer/logic/view_models/user_viewModel.dart';
import 'package:farmer/services/push_notifications.dart';
import 'package:farmer/views/widgets/receipt_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/sevice_locator.dart';
import '../../logic/view_models/home_viewModel.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  HomeViewModel model = serviceLocator<HomeViewModel>();

  @override
  void initState() {
    model.scaffoldKey = scaffoldKey;
    Future.delayed(Duration.zero, () {
      loadData();
    });
    super.initState();
  }

  void loadData() async {
    HelperMethods.showLoadingDialog('Loading...', context);
    await serviceLocator<UserViewModel>().getUserData();
    await model.getAmountDue();
    await model.getPayments();

    PushNotifications().initialize(context);
    PushNotifications().getToken();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<HomeViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
                leading: Container(),
                actions: <Widget>[
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: model.pending > 0
                        ? GestureDetector(
                            onTap: () {
                              showReceipts();
                            },
                            child: Text(
                              model.pending.toString(),
                              style: TextStyle(
                                  color: ThemeColors.colorAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : IconButton(
                            icon: Icon(
                              Icons.attach_money,
                              color: ThemeColors.colorAccent,
                            ),
                            onPressed: () {
                              showReceipts();
                            },
                          ),
                  ),
                ],
                centerTitle: true,
                title: Text('Home')),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('collections')
                  .where('id', isEqualTo: model.userViewModel.appUser.id)
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          elevation: 3.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Text(
                                    'Amount Due',
                                    style: TextStyle(
                                        color: ThemeColors.colorPrimary,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Ksh ' + model.amountDue.toString(),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: ThemeColors.colorAccent,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: ThemeColors.colorPrimary,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: Text(
                                  'Date',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                )),
                                Expanded(
                                  child: Text(
                                    'Kgs',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Ksh',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Status',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            var collection = snapshot.data.docs[index];
                            return Card(
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      collection['date'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    )),
                                    Expanded(
                                      child: Text(
                                        collection['kgs'].toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        (collection['kgs'] *
                                                collection['price'])
                                            .toInt()
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        collection['status'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: collection['status'] ==
                                                    'Pending'
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  void showReceipts() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text(
          'Payments',
          style: TextStyle(color: ThemeColors.colorPrimary),
        ),
        content: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('receipts')
              .where('id', isEqualTo: model.userViewModel.appUser.id)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
      ),
    );
    model.viewPayments();
  }
}
