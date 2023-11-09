import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../constants/sevice_locator.dart';
import '../../logic/view_models/report_viewModel.dart';

class ReceiptCard extends StatelessWidget {
  final DocumentSnapshot receipt;

  const ReceiptCard({Key key, this.receipt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => serviceLocator<ReportViewModel>(),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Date: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat.yMMMd().format((receipt['dateTime']).toDate()),
                    style: TextStyle(),
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'Farmer ID: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    receipt['id'].toString(),
                    style: TextStyle(),
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'Amount: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Ksh ' + receipt['amount'].toString(),
                    style: TextStyle(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
