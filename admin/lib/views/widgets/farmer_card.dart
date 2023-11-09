import 'package:dairyadmin/constants/sevice_locator.dart';
import 'package:dairyadmin/constants/theme_colors.dart';
import 'package:dairyadmin/logic/view_models/report_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'custom_avatar.dart';

class FarmerCard extends StatelessWidget {
  final DocumentSnapshot farmer;
  final Function editId;
  final Function viewReport;

  const FarmerCard({Key key, this.farmer, this.editId, this.viewReport})
      : super(key: key);

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
                  CustomAvatar(avatarUrl: farmer['avatarUrl']),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmer['firstName'] + ' ' + farmer['lastName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        farmer['id'] == 0 ? 'No id' : farmer['id'].toString(),
                      )
                    ],
                  ),
                  Spacer(),
                  farmer['id'] == 0
                      ? GestureDetector(
                          onTap: () {
                            editId(farmer.id);
                          },
                          child: Icon(
                            Icons.edit,
                            color: ThemeColors.colorAccent,
                          ),
                        )
                      : Container(),
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      viewReport(farmer['id'], farmer['firstName']);
                    },
                    child: Icon(
                      Icons.report,
                      color: ThemeColors.colorAccent,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
