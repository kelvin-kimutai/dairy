import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairyadmin/constants/helper_methods.dart';
import 'package:dairyadmin/constants/theme_colors.dart';
import 'package:dairyadmin/logic/view_models/report_viewModel.dart';
import 'package:dairyadmin/views/widgets/confirm_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/sevice_locator.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({Key key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ReportViewModel model = serviceLocator<ReportViewModel>();
  String farmerName = '';
  int farmerId;

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
    var routeArgs = ModalRoute.of(context).settings.arguments as Map;
    model.farmerId = routeArgs['id'];
    farmerId = routeArgs['id'];
    await model.getAmountDue();
    Navigator.pop(context);
    setState(() {
      farmerName = routeArgs['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(centerTitle: true, title: Text(farmerName + '\'s Report')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('collections')
            .where('id', isEqualTo: farmerId)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: ChangeNotifierProvider.value(
                value: model,
                child: Consumer<ReportViewModel>(
                  builder: (context, model, child) {
                    return Column(
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
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        isDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            ConfirmSheet(
                                          title: 'Pay farmer',
                                          text:
                                              'Amount due will be cleared and a receipt will be generated. Are you sure you would like to proceed?',
                                          confirm: () async {
                                            HelperMethods.showLoadingDialog(
                                                'Completing transaction...',
                                                context);
                                            await model.payFarmer();
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            HelperMethods.showSnackBar(
                                                'Receipt has been generated',
                                                scaffoldKey,
                                                Colors.green);
                                          },
                                        ),
                                      );
                                    },
                                    color: ThemeColors.colorAccent,
                                    textColor: Colors.white,
                                    child: Text('Pay farmer'),
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
                                    'Purchases',
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
                                      (collection['date'])
                                          .toString()
                                          .substring(5),
                                      maxLines: 2,
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    )),
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
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
