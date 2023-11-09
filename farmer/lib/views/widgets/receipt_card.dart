import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptCard extends StatelessWidget {
  final DocumentSnapshot receipt;

  const ReceiptCard({Key key, this.receipt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
